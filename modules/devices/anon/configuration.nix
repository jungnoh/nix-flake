# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) username;
  mesaDriversPath = "${pkgs.mesa}/lib/dri";
  xorgWrapper = pkgs.writeShellScript "xorg-xrdp-wrapper" ''
    export LIBGL_DRIVERS_PATH=${mesaDriversPath}
    export LIBVA_DRIVERS_PATH=${mesaDriversPath}
    export EGL_PLATFORM=drm
    exec ${pkgs.xorg.xorgserver}/bin/Xorg "$@"
  '';

  defaultNIC = "enp5s0";
  vmNIC = "enp3s0";
  vmSubnet = "192.168.122.0/24";

  ipRoute2 = "${pkgs.iproute2}/bin/ip";

  # FlyGoat fork carrying neutrinolabs/xrdp PR #3774 (FFmpeg/dma-buf VAAPI/Vulkan H.264).
  # The xorg-side dma-buf protocol changes live in a matching xorgxrdp branch.
  # nixpkgs' dynamic_config.patch is skipped — it doesn't apply to FlyGoat's
  # devel base. Replaced by --sysconfdir=/etc + a runtime rsakeys.ini symlink
  # below; absolute certificate=/key_file= in xrdp.ini are honoured by
  # unpatched xrdp already.
  xrdpFlyGoatSrc = pkgs.fetchFromGitHub {
    owner = "FlyGoat";
    repo = "xrdp";
    rev = "f52a35c559a11786084442c43668d66eff84ca0d";
    hash = "sha256-6GBC5hWP+8XW1ZY0N1612Zm/plbzKw5us2l4cD65YH0=";
    fetchSubmodules = true;
  };
  xorgxrdpHwAccel = pkgs.xrdp.passthru.xorgxrdp.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "FlyGoat";
      repo = "xorgxrdp";
      rev = "fb76740045dd0a2928dcfe1b51ed9335e7c03225";
      hash = "sha256-Gre6Na2cmvPgMcKtkoj239q+oywKDeNcPVg07gnl/jk=";
    };
    # Point header lookups at the FlyGoat xrdp tree — the dma-buf protocol
    # additions live in headers absent from upstream's common/ dir.
    preConfigure = ''
      ./bootstrap
      export XRDP_CFLAGS="-I${xrdpFlyGoatSrc}/common -I${pkgs.libdrm.dev}/include -I${pkgs.libdrm.dev}/include/libdrm"
    '';
  });
  xrdpHwAccel = pkgs.xrdp.overrideAttrs (old: {
    src = xrdpFlyGoatSrc;
    buildInputs = old.buildInputs ++ [
      pkgs.ffmpeg
      pkgs.libdrm
      pkgs.libva
      pkgs.x264
      pkgs.xorg.libxkbfile
    ];
    configureFlags = (old.configureFlags or [ ]) ++ [
      "--enable-ffmpeg"
      "--enable-x264"
      # Compile-time XRDP_CFG_PATH = /etc/xrdp; install still goes to $out
      # via existing DESTDIR= installFlags. Replaces the keymaps_path hunks
      # of dynamic_config.patch that did not apply.
      "--sysconfdir=/etc"
    ];
    # nixpkgs' postInstall hardcodes the inline xorgxrdp store path; rewrite it.
    # Also inject the #rsakeys_ini placeholder that nixpkgs xrdp.nix module
    # expects to substitute (normally added by dynamic_config.patch).
    postInstall = (old.postInstall or "") + ''
      substituteInPlace $out/etc/xrdp/sesman.ini \
        --replace-fail '${pkgs.xrdp.passthru.xorgxrdp}' '${xorgxrdpHwAccel}'
      sed -i '/^\[Globals\]/a #rsakeys_ini=' $out/etc/xrdp/xrdp.ini
    '';
  });
in
{
  imports = [
    ./hardware.nix
    ../../packages/03-apps/vscode
  ];

  environment.systemPackages = with pkgs; [
    dnsmasq
    psmisc
    xdriinfo
    xorg.xdpyinfo
    bintools
    (pkgs.writeShellScriptBin "mount-data" ''
      sudo cryptsetup open /dev/disk/by-partlabel/disk-data-data cryptdata
      sudo mount /dev/mapper/cryptdata /mnt/data
    '')
    (pkgs.writeShellScriptBin "umount-data" ''
      sudo umount /mnt/data
      sudo cryptsetup close cryptdata
    '')
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable WOL
  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 ];

  # Use different NICs for VM / everything else
  networking.iproute2 = {
    enable = true;
    rttablesExtraConfig = "200 vm_traffic";
  };
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "vm-routing" ''
        INTERFACE=$1
        ACTION=$2

        # Only act when VM iface or virbr0 comes up
        if [ "$INTERFACE" = "${vmNIC}" ]; then
          if [ "$ACTION" = "up" ] || [ "$ACTION" = "dhcp4-change" ]; then
            VM_NIC_IP=$(echo "$IP4_ADDRESS_0" | cut -d'/' -f1)
            ${ipRoute2} route replace default via "$IP4_GATEWAY" dev ${vmNIC} src "$VM_NIC_IP" table vm_traffic 2>/dev/null || true
            ${ipRoute2} rule add fwmark 0x1 table vm_traffic priority 100 2>/dev/null || true
            ${ipRoute2} route flush cache
          fi
          if [ "$ACTION" = "down" ]; then
            ${ipRoute2} rule del fwmark 0x1 table vm_traffic priority 100 2>/dev/null || true
            ${ipRoute2} route flush table vm_traffic 2>/dev/null || true
          fi
        fi
      '';
    }
  ];
  systemd.services.vm-routing-virbr0 = {
    after = [
      "libvirtd.service"
      "network-online.target"
    ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    script = ''
      ${ipRoute2} route replace ${vmSubnet} dev virbr0 table vm_traffic
      ${ipRoute2} route replace ${vmSubnet} dev virbr0 table main
      ${ipRoute2} route flush cache
    '';
  };

  networking.firewall.checkReversePath = "loose";
  networking.networkmanager.ensureProfiles = {
    profiles = {
      "${defaultNIC}" = {
        connection = {
          id = defaultNIC;
          type = "ethernet";
          interface-name = defaultNIC;
        };
        ipv4 = {
          method = "auto";
          route-metric = "100";
        };
      };
      "${vmNIC}" = {
        connection = {
          id = vmNIC;
          type = "ethernet";
          interface-name = vmNIC;
        };
        ipv4 = {
          method = "auto";
          route-metric = "101";
        };
      };
    };
  };

  networking.firewall.extraCommands = ''
    iptables -D FORWARD -i virbr0 -o ${vmNIC} -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -i ${vmNIC} -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    iptables -t nat -D POSTROUTING -s ${vmSubnet} ! -d ${vmSubnet} -o ${vmNIC} -j MASQUERADE 2>/dev/null || true
    iptables -t mangle -D PREROUTING -i virbr0 -s ${vmSubnet} -j MARK --set-mark 0x1 2>/dev/null || true

    iptables -t mangle -I PREROUTING -i virbr0 -s ${vmSubnet} -j MARK --set-mark 0x1

    iptables -I FORWARD -i virbr0 -o ${vmNIC} -j ACCEPT
    iptables -I FORWARD -i ${vmNIC} -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -t nat -I POSTROUTING -s ${vmSubnet} ! -d ${vmSubnet} -o ${vmNIC} -j MASQUERADE
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D FORWARD -i virbr0 -o ${vmNIC} -j ACCEPT 2>/dev/null || true
    iptables -D FORWARD -i ${vmNIC} -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    iptables -t nat -D POSTROUTING -s ${vmSubnet} ! -d ${vmSubnet} -o ${vmNIC} -j MASQUERADE 2>/dev/null || true
    iptables -t mangle -D PREROUTING -i virbr0 -s ${vmSubnet} -j MARK --set-mark 0x1 2>/dev/null || true
  '';
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;

    # WAN-friendly TCP for xrdp
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_notsent_lowat" = 16384;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    initialPassword = "mygo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
    ];
  };
  users.users.xrdp.extraGroups = [
    "video"
    "render"
  ];

  services = {
    xrdp = {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "xfce4-session";
      package = xrdpHwAccel;
      extraConfDirCommands = ''
          # Enable h264
          sed -i '/\[Xorg\]/a codec_id=20' $out/xrdp.ini

          # Cap color depth to 24bpp
          sed -i 's/^max_bpp=32$/max_bpp=24/' $out/xrdp.ini

          # Make xrdp + sesman log to stderr so journalctl -u xrdp* sees them.
          # Default is EnableConsole=false; LogFile stays /dev/null because xrdp
          # tries to open it as a regular file post-fork and chokes on /dev/stderr.
          for f in xrdp.ini sesman.ini; do
            sed -i \
              -e 's|^#EnableConsole=false|EnableConsole=true|' \
              -e 's|^#ConsoleLevel=INFO|ConsoleLevel=DEBUG|' \
              $out/$f
          done

          # Unpatched xrdp opens XRDP_CFG_PATH/rsakeys.ini directly; redirect
          # to the runtime-generated keys produced by the xrdp.service preStart.
          ln -sf /run/xrdp/rsakeys.ini $out/rsakeys.ini

          # Hardware H.264 via FFmpeg/VAAPI (PR #3774 backend).
          # The encoder value is "FFmpeg" (mixed case, per gfx.toml comment);
          # path lives in the global [FFmpeg] table.
          sed -i 's/^h264_encoder = "x264"/h264_encoder = "FFmpeg"/' $out/gfx.toml
          sed -i 's|^path = "software"|path = "vaapi"|' $out/gfx.toml

          ORIG_CONF=$(grep -A1 'param=-config' $out/sesman.ini | tail -1 | sed 's/param=//')
          cp "$ORIG_CONF" $out/xorg.conf

          substituteInPlace $out/xorg.conf \
            --replace 'Load "fb"' 'Load "fb"
          Load "dri3"
          Load "glamoregl"' \
            --replace 'Section "Device"' 'Section "Device"
          Option "UseGlamor" "true"'

          substituteInPlace $out/sesman.ini \
            --replace "$ORIG_CONF" '/etc/xrdp/xorg.conf' \
            --replace 'param=.xorgxrdp.%s.log' 'param=.xorgxrdp.%s.log
        param=-seat
        param=seat-xrdp' \
            --replace '[Xorg]' '[Xorg]
        param=${xorgWrapper}'

          sed -i '/param=.*xorg-server.*bin\/Xorg/d' $out/sesman.ini
      '';
    };

    displayManager.defaultSession = "xfce";
    xserver = {
      enable = false;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };

      # Configure keymap in X11
      xkb = {
        layout = "kr";
        variant = "";
      };
    };
  };

  # Nice is inherited by sesman's forked Xorg children, so the per-session
  # encoder also runs at -5. OOMScoreAdjust shields xrdp from systemd-oomd.
  systemd.services.xrdp.serviceConfig = {
    Nice = -5;
    CPUWeight = 500;
    IOWeight = 500;
    OOMScoreAdjust = -500;
  };
  systemd.services.xrdp-sesman.serviceConfig = {
    Nice = -5;
    CPUWeight = 500;
    IOWeight = 500;
    OOMScoreAdjust = -500;
  };

  # Encoding runs inside the xrdp daemon (the xup module), not the per-user
  # Xorg, so libva needs to find the AMD driver in xrdp.service's env or it
  # silently falls back to software x264 — i.e. the 100% CPU symptom.
  systemd.services.xrdp.environment = {
    LIBVA_DRIVERS_PATH = "${pkgs.mesa}/lib/dri";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  services.udev.extraRules = ''
    # Attach the GPU and its renderD node to seat-xrdp
    SUBSYSTEM=="drm", KERNEL=="card1",       TAG+="seat", ENV{ID_SEAT}="seat-xrdp", TAG+="uaccess"
    SUBSYSTEM=="drm", KERNEL=="renderD128",  TAG+="seat", ENV{ID_SEAT}="seat-xrdp", TAG+="uaccess"

    # Also attach the PCI device itself so logind recognises the seat as having a master device
    # Replace with your actual PCI path from step 1
    SUBSYSTEMS=="pci", KERNEL=="0000:06:00.0", TAG+="seat", ENV{ID_SEAT}="seat-xrdp"
  '';

  security.pam.services.xrdp-sesman = {
    text = ''
      auth      requisite    pam_nologin.so
      auth      include      login
      account   include      login
      password  include      login

      # Set XDG_SEAT before pam_systemd runs so the session is created on seat-xrdp
      session   required     pam_env.so envfile=/etc/xrdp/xrdp-seat.env
      session   required     pam_loginuid.so
      session   required     ${pkgs.systemd}/lib/security/pam_systemd.so
      session   include      login
    '';
  };

  environment.etc."xrdp/xrdp-seat.env".text = ''
    XDG_SEAT=seat-xrdp
    XDG_SESSION_TYPE=x11
  '';

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) username;

  defaultNIC = "enp5s0";
in
{
  environment.systemPackages = with pkgs; [
    dnsmasq
    psmisc
    xdriinfo
    xorg.xdpyinfo
    xrandr
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

  # Keep NetworkManager off libvirt-owned interfaces, otherwise it tries to
  # manage virbr0/vnet* and leaves the bridge admin-down, breaking VM egress.
  networking.networkmanager.unmanaged = [
    "interface-name:virbr*"
    "interface-name:vnet*"
  ];

  # Enable WOL
  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 ];

  networking.nftables.enable = true;

  # Let libvirt VMs on the default NAT bridge reach the internet. The main
  # firewall's forward chain otherwise drops their packets even though
  # libvirt installs its own NAT rules.
  networking.firewall.extraForwardRules = ''
    iifname "virbr0" ip saddr 192.168.122.0/24 accept comment "libvirt NAT egress"
    oifname "virbr0" ct state related,established accept comment "libvirt NAT return path"
  '';

  # Use libvirt's native nftables backend rather than the iptables-nft shim,
  # which avoids ordering issues when networking.nftables.enable = true.
  environment.etc."libvirt/network.conf".text = ''
    firewall_backend = "nftables"
  '';

  networking.firewall.interfaces.virbr0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
      67
    ];
  };

  networking.networkmanager.dns = "default";
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
          ignore-auto-dns = "true";
        };
      };
    };
  };

  boot.kernel.sysctl = {
    # Smooth UDP bursts toward the soyo subnet router for Sunshine streaming.
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
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
      "input"
      "uinput"
    ];
  };
  services = {
    # Lay out monitors before the greeter draws so lightdm appears on
    # the DVI/KVM head (HDMI-A-2), not on the HDMI dummy plug (HDMI-A-1).
    xserver.displayManager.lightdm.extraSeatDefaults = ''
      display-setup-script=${pkgs.writeShellScript "lightdm-display-setup" ''
        ${pkgs.xrandr}/bin/xrandr \
          --output HDMI-A-2 --auto --primary \
          --output HDMI-A-1 --auto --right-of HDMI-A-2 || true
      ''}
    '';

    # HDMI-A-2 = physical DVI port (KVM, primary, where lightdm appears).
    # HDMI-A-1 = physical HDMI port with dummy plug, captured by Sunshine.
    xserver.displayManager.sessionCommands = ''
      ${pkgs.xrandr}/bin/xrandr \
        --output HDMI-A-2 --auto --primary \
        --output HDMI-A-1 --auto --right-of HDMI-A-2 || true
    '';

    sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;

      settings = {
        capture = "x11";
        encoder = "vaapi";
        min_log_level = "info";
        origin_web_ui_allowed = "lan";
        # KVM is on DVI; HDMI has a dummy plug for the headless stream.
        output_name = "HDMI-A-1";
      };
    };
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Stop the screen blanker from killing your stream after 10 minutes
  services.xserver.serverFlagsSection = ''
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
  '';

  hardware.uinput.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager = {
    enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

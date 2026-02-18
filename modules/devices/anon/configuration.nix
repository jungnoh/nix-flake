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
  wallpaper = ./wallpaper.jpg;
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

  networking.hostName = "anon"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable WOL
  networking.interfaces.enp4s0.wakeOnLan.enable = true;
  networking.firewall.allowedUDPPorts = [ 9 ];

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
      extraConfDirCommands = ''
              ORIG_CONF=$(grep -A1 'param=-config' $out/sesman.ini | tail -1 | sed 's/param=//')
              cp "$ORIG_CONF" $out/xorg.conf

              substituteInPlace $out/xorg.conf \
                --replace 'Load "fb"' 'Load "fb"
                Load "dri3"'

              cat >> $out/xorg.conf <<EOF

              Section "ServerFlags"
                Option "AutoAddGPU" "false"
                Option "AutoBindGPU" "false"
              EndSection
        EOF

              substituteInPlace $out/sesman.ini \
                --replace "$ORIG_CONF" '/etc/xrdp/xorg.conf' \
                --replace 'param=.xorgxrdp.%s.log' 'param=.xorgxrdp.%s.log
                param=-seat
                param=seat-xrdp'
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
  programs.virt-manager.enable = true;

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

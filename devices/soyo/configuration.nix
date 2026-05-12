{
  lib,
  pkgs,
  ...
}:
let
  username = "jungnoh";
in
{
  config = {
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    services.openssh.enable = true;

    environment.systemPackages = map lib.lowPrio [
      pkgs.curl
      pkgs.gitMinimal
    ];

    users.mutableUsers = true;
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      initialPassword = "mygo";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "podman"
      ];
    };
    users.users.forgejo.extraGroups = [ "podman" ];

    system.stateVersion = "25.11";
  };
}

{
  lib,
  pkgs,
  ...
}@args:
let
  username = "jungnoh";
in
{
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJL8gwfkX0ql5CYkDVTq/RmEICwHLw5E+Ajb7e9czJHj jungnoh@tomori"
  ]
  ++ (args.extraPublicKeys or [ ]); # this is used for unit-testing this module and can be removed if not needed

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    initialPassword = "mygo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  system.stateVersion = "25.11";
}

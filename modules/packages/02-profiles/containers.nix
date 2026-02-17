# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
in
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs.unstable; [
        colima
        lima
        docker
        docker-compose
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "utm"
      ];
    })
    (onlyLinux {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      home.packages = with pkgs.unstable; [
        virtio-win
      ];
    })
  ];
}

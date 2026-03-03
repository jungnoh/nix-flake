# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
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
      home.packages = with pkgs; [
        colima
        lima
        docker
        docker-compose
      ];
    }
    (onlyDarwin {
      home.packages = with pkgs; [
        utm
      ];
    })
    (onlyLinux {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      home.packages = with pkgs; [
        virtio-win
      ];
    })
  ];
}

# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
    colima
    lima
    docker
    docker-compose
    virtio-win
  ];

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}

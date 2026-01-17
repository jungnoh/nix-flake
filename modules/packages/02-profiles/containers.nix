# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    home.packages = with pkgs.unstable; [
      colima
      lima
      docker
      docker-compose
    ];
  };
}

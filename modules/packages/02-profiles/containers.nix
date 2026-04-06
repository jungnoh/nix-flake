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
        docker
        docker-compose
      ];
    }
    (onlyDarwin {
      home.packages = with pkgs; [
        colima
        lima
      ];
    })
    (onlyLinux {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
        };
      };
    })
  ];
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) onlyDarwin onlyLinux;
in
with lib;
{
  options.myOptions.containers.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf config.myOptions.containers.enable (mkMerge [
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
  ]);
}

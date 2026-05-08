{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) onlyLinux byPlatform;
  virtConfig = config.myOptions.virtualization;

  containerCfg = byPlatform {
    common = {
      home.packages = with pkgs; [
        docker
        docker-compose
      ];
    };
    darwin = {
      home.packages = with pkgs; [
        colima
        lima
      ];
    };
    linux = {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
        };
      };
    };
  };

  virtManagerCfg = onlyLinux {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
in
with lib;
{
  options.myOptions.virtualization = {
    containers.enable = mkOption {
      type = types.bool;
      default = false;
    };
    virt-manager.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf virtConfig.containers.enable containerCfg)
    (mkIf virtConfig.virt-manager.enable virtManagerCfg)
  ];
}

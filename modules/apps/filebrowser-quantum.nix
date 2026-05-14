{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.filebrowser-quantum;
  format = pkgs.formats.yaml { };
  inherit (lib) types;
in
{
  options = {
    services.filebrowser-quantum = {
      enable = lib.mkEnableOption "Filebrowser Quantum";
      package = lib.mkPackageOption pkgs "filebrowser-quantum" { };

      user = lib.mkOption {
        type = types.str;
        default = "fb-quantum";
      };

      group = lib.mkOption {
        type = types.str;
        default = "fb-quantum";
      };

      openFirewall = lib.mkEnableOption "Open filewall ports";

      settings = lib.mkOption {
        default = { };
        description = ''
          Refer to <https://filebrowserquantum.com/en/docs/configuration/configuration-overview/> for all supported values.
        '';
        type = types.submodule {
          freeformType = format.type;

          options = {
            server = {
              type = types.submodule {
                freeformType = format.type;
                options = {
                  listen = lib.mkOption {
                    default = "localhost";
                    description = ''
                      The address to listen on.
                    '';
                    type = types.str;
                  };

                  port = lib.mkOption {
                    default = 8080;
                    description = ''
                      The port to listen on.
                    '';
                    type = types.port;
                  };

                  cacheDir = lib.mkOption {
                    default = "/var/cache/filebrowser-quantum";
                    type = types.path;
                    readOnly = true;
                  };

                  database = lib.mkOption {
                    default = "/var/lib/filebrowser-quantum/database.db";
                    type = types.path;
                  };

                  sources = lib.mkOption {
                    type = types.listOf (
                      types.submodule {
                        options = {
                          path = lib.mkOption {
                            type = types.path;
                          };
                          name = lib.mkOption {
                            type = types.str;
                          };
                          config = lib.mkOption {
                            type = types.submodule {
                              freeformType = format.type;
                            };
                            default = { };
                          };
                        };
                      }
                    );
                  };
                };
              };
            };

            auth = {
              type = types.submodule {
                freeformType = format.type;
                options = {
                  adminUsername = lib.mkOption {
                    type = types.str;
                    default = "admin";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.filebrowser-quantum = {
        after = [ "network.target" ];
        description = "Filebrowser Quantum";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart =
            let
              args = [
                (lib.getExe cfg.package)
                "--config"
                (format.generate "config.yaml" cfg.settings)
              ];
            in
            utils.escapeSystemdExecArgs args;

          StateDirectory = "filebrowser-quantum";
          CacheDirectory = "filebrowser-quantum";
          WorkingDirectory = cfg.settings.root;

          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";

          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          DevicePolicy = "closed";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };

      tmpfiles.settings.filebrowser = {
        "${cfg.settings.root}".d = {
          inherit (cfg) user group;
          mode = "0700";
        };
        "${cfg.settings.cache-dir}".d = {
          inherit (cfg) user group;
          mode = "0700";
        };
        "${dirOf cfg.settings.database}".d = {
          inherit (cfg) user group;
          mode = "0700";
        };
      };
    };

    users.users = lib.mkIf (cfg.user == "filebrowser-quantum") {
      filebrowser-quantum = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "filebrowser-quantum") {
      filebrowser-quantum = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];
  };
}

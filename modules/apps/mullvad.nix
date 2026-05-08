{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  enable = config.myOptions.mullvad.enable;
in
{
  options.myOptions.mullvad = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf enable (byPlatform {
    darwin = {
      homebrew.casks = [
        "mullvad-vpn"
      ];
    };
    linux = {
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = true;
          DNSSEC = true;
          Domains = [ "~." ];
          FallbackDNS = [
            "1.1.1.1#one.one.one.one"
            "1.0.0.1#one.one.one.one"
          ];
        };
      };
    };
  });
}

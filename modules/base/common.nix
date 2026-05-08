{ inputs, system, ... }:
let
  inherit (inputs) lib;
in
{
  options.myOptions = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Asia/Seoul";
      description = "Time zone to be used in system.";
    };
  };

  config = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (final: prev: {
        master = import inputs.nixpkgs-master {
          inherit system;
          config.allowUnfree = true;
        };
      })
    ];
  };
}

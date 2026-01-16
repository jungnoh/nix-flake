{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) isDarwin isLinux;
  inherit (lib) mkIf;
in
{
  # TODO: Wireguard
  config =
    mkIf isDarwin {
      homebrew.casks = [
        "slack"
        "figma"
      ];
    }
    // mkIf isLinux {
      home.packages = with pkgs.unstable; [
        slack
      ];
    };
}

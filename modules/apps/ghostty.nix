{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) isDarwin;
  themeFile = pkgs.writeText "ghostty-theme-adventure" ''
    palette = 0=#040404
    palette = 1=#d84a33
    palette = 2=#5da602
    palette = 3=#eebb6e
    palette = 4=#417ab3
    palette = 5=#e5c499
    palette = 6=#bdcfe5
    palette = 7=#dbded8
    palette = 8=#685656
    palette = 9=#d76b42
    palette = 10=#99b52c
    palette = 11=#ffb670
    palette = 12=#97d7ef
    palette = 13=#aa7900
    palette = 14=#bdcfe5
    palette = 15=#e4d5c7
    background = #040404
    foreground = #feffff
    cursor-color = #feffff
    cursor-text = #000000
    selection-background = #606060
    selection-foreground = #ffffff
  '';
in
with lib;
{
  options.myOptions.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.myOptions.ghostty.enable {
    home.packages = with pkgs; if isDarwin then [ ghostty-bin ] else [ ghostty ];
    home.configFile."ghostty/config".source = pkgs.writeText "ghostty-config" ''
      auto-update = "off"
      shell-integration-features = "ssh-env, ssh-terminfo"
      theme = "${themeFile}"
    '';
  };
}

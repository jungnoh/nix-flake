# Common applications that are used in a desktop environment
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
  config =
    onlyDarwin {
      homebrew.casks = [
        "google-chrome"
        # macOS Only
        "iterm2"
        "fuwari"
        "betterdisplay"
      ];
      homebrew.masApps = {
        "Magnet" = 441258766;
        "Amphetemine" = 937984704;
      };
    }
    // onlyLinux {
      programs.firefox.enable = true;
      home.packages = with pkgs.unstable; [
        google-chrome
      ];
    };
}

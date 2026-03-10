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
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        google-chrome
      ];
      home.configFile."ghostty/config".source = pkgs.writeText "ghostty-config" ''
        auto-update = "off"
        theme = "adventure"
        shell-integration-features = "ssh-env"
      '';
    }
    (onlyDarwin {
      home.packages = with pkgs; [
        betterdisplay
        ghostty-bin
      ];
      homebrew.casks = [
        "fuwari"
      ];
      homebrew.masApps = {
        "Magnet" = 441258766;
        "Amphetemine" = 937984704;
      };
    })
    (onlyLinux {
      programs.firefox.enable = true;
      home.packages = with pkgs; [
        parted
        ghostty
      ];
    })
  ];
}

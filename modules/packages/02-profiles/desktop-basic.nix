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
    }
    (onlyDarwin {
      home.packages = with pkgs; [
        betterdisplay
        iterm2
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
      ];
    })
  ];
}

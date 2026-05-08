# Common applications that are used in a desktop environment
{
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (lib) onlyDarwin onlyLinux;
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

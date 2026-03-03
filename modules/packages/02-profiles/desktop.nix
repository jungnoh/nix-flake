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
        notion-app
        telegram-desktop
        spotify
        obsidian
        _1password-gui
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        # Claude Code is installed at dev-env.nix
        "claude"
      ];
      homebrew.masApps = {
        "KakaoTalk" = 869223134;
        "한컴오피스 한글 Viewer" = 416746898;
        "Windows App" = 1295203466;
      };
      home.packages = with pkgs; [
        nixd
      ];
    })
    (onlyLinux {
      environment.systemPackages = with pkgs; [
        nixd
      ];
      home.packages = with pkgs; [
        remmina
        mpv
      ];
    })
  ];
}

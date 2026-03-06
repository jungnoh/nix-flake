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
        telegram-desktop
        spotify
        obsidian
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "1password"
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
        notion-app
      ];
    })
    (onlyLinux {
      environment.systemPackages = with pkgs; [
        nixd
      ];
      home.packages = with pkgs; [
        remmina
        mpv
        _1password-gui
      ];
    })
  ];
}

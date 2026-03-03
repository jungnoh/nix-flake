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
    (onlyDarwin {
      homebrew.casks = [
        "notion"
        "telegram"
        "spotify"
        "obsidian"
        "1password"
        # macOS Only
        "claude" # Claude Code is installed at dev-env.nix
        "iterm2"
        "fuwari"
        "betterdisplay"
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
        telegram-desktop
        spotify
        obsidian
        remmina
        mpv
        _1password-gui
      ];
    })
  ];
}

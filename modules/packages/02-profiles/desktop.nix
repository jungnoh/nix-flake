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
      home.packages = with pkgs.unstable; [
        remmina
      ];
    }
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
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        telegram-desktop
        spotify
        obsidian
        _1password-gui
      ];
      home.programs.plasma.pinnedApplications = [
        "applications:firefox.desktop"
        "applications:discord.desktop"
        "applications:spotify.desktop"
        "applications:telegram.desktop"
        "applications:cursor-url-handler.desktop"
      ];
    })
  ];
}

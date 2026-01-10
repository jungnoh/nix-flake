{ config, lib, pkgs, ... }:
{
  config = {
    homebrew.brews = [
      "asdf"
      "kwctl"
      "icu4c"
    ];
    homebrew.casks = [
      # Basic apps
      "google-chrome"
      "iterm2"
      "notion"
      "telegram"
      "spotify"
      "obsidian"
      "claude"
      "discord"
      # Dev tools
      "cursor"
      "insomnia"
      "db-browser-for-sqlite"
      # macOS tools
      "fuwari"
      "iina"
      "maccy"
      # For work
      "slack"
      "figma"
      "wireshark-app"
      "1password"
    ];
    homebrew.masApps = {
      "KakaoTalk" = 869223134;
      "Magnet" = 441258766;
      "Amphetemine" = 937984704;
      "한컴오피스 한글 Viewer" = 416746898;
      "Windows App" = 1295203466;
    };
  };
}

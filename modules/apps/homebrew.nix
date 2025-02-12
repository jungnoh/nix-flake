{ config, lib, pkgs, ... }:
{
  config = {
    homebrew.brews = [
      "asdf"
      "kwctl"
    ];
    homebrew.casks = [
      # Basic apps
      "google-chrome"
      "iterm2"
      "notion"
      "telegram"
      "spotify"
      # Dev tools
      "postman"
      # macOS tools
      "fuwari"
      "iina"
      "insomnia"
      "maccy"
      # For work
      "slack"
      "figma"
      "wireshark"
      "1password"
    ];
    homebrew.masApps = {
      "KakaoTalk" = 869223134;
      "EasyRes" = 688211836;
      "Magnet" = 441258766;
      "Amphetemine" = 937984704;
      "Red" = 1491764008;
      "한컴오피스 한글 Viewer" = 416746898;
      "Windows App" = 1295203466;
    };
  };
}

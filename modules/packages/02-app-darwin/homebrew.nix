{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    homebrew.casks = [
      # Basic apps
      "claude"
      "1password"
      # Dev tools
      "cursor"
      "insomnia"
      "db-browser-for-sqlite"
      # macOS tools
      # For work
      "slack"
      "figma"
      "wireshark-app"
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

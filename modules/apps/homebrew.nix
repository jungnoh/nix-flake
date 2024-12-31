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
  };
}

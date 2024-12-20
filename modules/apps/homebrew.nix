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
      "librewolf"
      "spotify"
      # Dev tools
      "podman-desktop"
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

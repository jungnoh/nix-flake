{ config, lib, pkgs, ... }:
{
  config = {
    homebrew.brews = [
      "tailscale"
    ];
    home.programs.zsh.shellAliases = {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}
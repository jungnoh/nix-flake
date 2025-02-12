{ config, lib, pkgs, ... }:
{
  config = {
    homebrew.casks = [
      "tailscale"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}
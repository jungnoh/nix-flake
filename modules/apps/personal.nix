{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      typst
      font-awesome
    ];
    homebrew.casks = [
      "tailscale-app"
      "losslesscut"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}

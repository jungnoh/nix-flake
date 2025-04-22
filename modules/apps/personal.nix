{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      cmake
      jetbrains.clion
      mullvad-vpn
    ];
    homebrew.casks = [
      "tailscale"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}
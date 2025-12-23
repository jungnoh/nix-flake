{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      typst
      font-awesome
      rclone
    ];
    homebrew.casks = [
      "tailscale-app"
      "losslesscut"
      "mullvad-vpn"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}

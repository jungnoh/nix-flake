{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      typst
      font-awesome
      rclone
    ];
    homebrew.brews = [
      "gemini-cli"
    ];
    homebrew.casks = [
      "tailscale-app"
      "losslesscut"
      "mullvad-vpn"
      "claude-code"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}

{ config, lib, pkgs, isDarwin, ... }:
{
  home.packages = with pkgs.unstable; [
    anki-bin
    gemini-cli-bin
    typst
    font-awesome
    rclone
  ];
} // lib.optionalAttrs isDarwin {
  homebrew.casks = [
    "tailscale-app"
    "losslesscut"
    "mullvad-vpn"
    "claude-code"
  ];
  home.programs.zsh.shellAliases = {
    tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
  };
}
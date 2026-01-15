{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      gemini-cli-bin
      typst
      font-awesome
      rclone
    ];
    
    homebrew.casks = lib.mkIf pkgs.stdenv.isDarwin [
      "tailscale-app"
      "losslesscut"
      "mullvad-vpn"
      "claude-code"
    ];

    home.programs.zsh.shellAliases = lib.mkIf pkgs.stdenv.isDarwin {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) isDarwin isLinux;
  inherit (lib) mkIf;
in
{
  config = {
    home.packages = with pkgs.unstable; [
      anki-bin
      gemini-cli-bin
      typst
      font-awesome
      rclone
    ];
  }
  // mkIf isDarwin {
    homebrew.casks = [
      "discord"
      "tailscale-app"
      "losslesscut"
      "mullvad-vpn"
      "claude-code"
    ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  }
  // mkIf isLinux {
    home.packages = with pkgs.unstable; [
      discord
    ];
  };
}

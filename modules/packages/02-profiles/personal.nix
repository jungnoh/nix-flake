{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
in
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs.unstable; [
        anki-bin
        gemini-cli-bin
        typst
        font-awesome
        rclone
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "discord"
        "slack"
        "tailscale-app"
        "losslesscut"
        "mullvad-vpn"
      ];
      home.programs.zsh.shellAliases = {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      };
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        discord
        slack
      ];
    })
  ];
}

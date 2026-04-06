{
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
      home.packages = with pkgs; [
        anki-bin
        gemini-cli-bin
        typst
        font-awesome
        rclone
        discord
        slack
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "mullvad-vpn"
        "tailscale-app"
      ];
      home.programs.zsh.shellAliases = {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      };
    })
    (onlyLinux {
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = true;
          DNSSEC = true;
          Domains = [ "~." ];
          FallbackDNS = [
            "1.1.1.1#one.one.one.one"
            "1.0.0.1#one.one.one.one"
          ];
        };
      };
    })
  ];
}

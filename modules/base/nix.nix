{ nixpkgs-unstable }:
{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
    (final: prev: {
      xrdp = prev.xrdp.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          final.mesa
          final.libdrm
          final.libepoxy
          final.xorg.xorgserver
        ];
        preConfigure = (old.preConfigure or "") + ''
          autoreconf -fi
        '';
        configureFlags = (old.configureFlags or [ ]) ++ [
          "--enable-glamor"
        ];
      });
    })
  ];
}

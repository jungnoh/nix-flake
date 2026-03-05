{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # Note: Code from https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/by-name/xr/xrdp/package.nix
    # Updates are needed when the upstream package is updated.
    (final: prev: {
      xrdp = prev.xrdp.overrideAttrs (
        old:
        let
          xorgxrdp = prev.xrdp.xorgxrdp.overrideAttrs (xorgOld: {
            buildInputs = xorgOld.buildInputs ++ [
              final.mesa
              final.libgbm
              final.libepoxy
            ];
            configureFlags = (xorgOld.configureFlags or [ ]) ++ [ "--enable-glamor" ];
          });
        in
        {
          postInstall = builtins.replaceStrings [ "${prev.xrdp.xorgxrdp}" ] [ "${xorgxrdp}" ] old.postInstall;
          passthru = old.passthru // {
            inherit xorgxrdp;
          };
        }
      );
    })
  ];
}

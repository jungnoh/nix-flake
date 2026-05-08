{ system }:
{ inputs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    })
  ];
}

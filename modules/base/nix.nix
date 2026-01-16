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
        system = prev.system;
        config.allowUnfree = true;
      };
    })
  ];
}

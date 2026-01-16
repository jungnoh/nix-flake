{ nixpkgs-unstable, ... }:
[
  ({ pkgs, ... }: {
    nixpkgs.overlays = (import ./overlays.nix {
      inherit nixpkgs-unstable;
    });
  })
  ./envs.nix
  ./home.nix
]
{ nixpkgs-unstable, ... }:
[
  (import ./nix.nix { inherit nixpkgs-unstable; })
  ./envs.nix
  ./home.nix
]

{ system }:
[
  (import ./nix.nix { inherit system; })
  ./envs.nix
  ./home.nix
]

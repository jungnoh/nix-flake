{ config, pkgs, nixpkgs-unstable, lib, system, ... }:
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  })
]

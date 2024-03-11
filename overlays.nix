{config, pkgs, nixpkgs-unstable, ...}:
let system = "aarch64-darwin";
in
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  })
]
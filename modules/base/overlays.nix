{ nixpkgs-unstable }:
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      system = prev.system;
      config.allowUnfree = true;
    };
  })
]

{ inputs }:
{ hostname
, system ? "x86_64-linux"
, username ? "jungnoh"
, extraModules ? [ ]
, includePersonal ? false
}:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = import ./overlays.nix {
      inherit system pkgs;
      config = { };
      lib = inputs.nixpkgs.lib;
      nixpkgs-unstable = inputs.nixpkgs-unstable;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs username; };
  modules = [
    (import ./home.nix)
    (import ./envs.nix)
  ]
  ++ import ../modules/00-root/linux.nix { inherit profiles; };
}

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

  personalModules =
    if includePersonal
    then import ../modules/personal.nix { inherit system; }
    else [ ];
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs username; };
  modules = [
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      nixpkgs.config.allowUnfree = true;
    }
  ] ++ import ../modules/common.nix { inherit system; }
  ++ personalModules
  ++ extraModules;
}

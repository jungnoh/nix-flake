{ nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
let
  system = "x86_64-linux";

  host = import ../mkHost.nix {
    inherit inputs system;
    system_modules = [
      ./configuration.nix
      ./hardware.nix
    ];
    features = ["personal"];
  };

in {
  nixosConfigurations."tomori" = nixpkgs.lib.nixosSystem {
    inherit (host) system modules specialArgs;
  };
}
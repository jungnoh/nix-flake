{ nixpkgs, nixpkgs-unstable, ... }@inputs:
let

  host = import ../mkHost.nix {
    inherit inputs;

    system = "x86_64-linux";
    system_modules = [
      ./configuration.nix
      ./hardware.nix
    ];
    features = [ "personal" ];
  };

in
{
  nixosConfigurations."tomori" = nixpkgs.lib.nixosSystem {
    inherit (host) system modules specialArgs;
  };
}

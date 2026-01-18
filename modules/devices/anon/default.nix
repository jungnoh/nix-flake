{ nixpkgs, nixpkgs-unstable, ... }@inputs:
let
  hostname = "anon";
  host = import ../mkHost.nix {
    inherit hostname inputs;

    system = "x86_64-linux";
    system_modules = [
      ./configuration.nix
      ./hardware.nix
    ];
    features = [
      "desktop-basic"
    ];
    languages = [];
  };

in
{
  nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    inherit (host) system modules specialArgs;
  };
}

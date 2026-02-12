{ nixpkgs, nixpkgs-unstable, ... }@inputs:
let
  hostname = "tomori";
  host = import ../mkHost.nix {
    inherit hostname inputs;

    system = "x86_64-linux";
    system_modules = [
      ./configuration.nix
      ./hardware.nix
    ];
    features = [
      "personal"
      "desktop"
      "dev-env"
      "containers"
    ];
    languages = [
      "rust"
      "golang"
      "dotnet"
      "node"
    ];
  };

in
{
  nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    inherit (host) system modules specialArgs;
  };
}

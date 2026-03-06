{ nixpkgs, ... }@inputs:
let
  hostname = "soyo";
  host = import ../mkHost.nix {
    inherit hostname inputs;

    system = "x86_64-linux";
    username = "jungnoh";
    use_agenix = true;
    system_modules = [
      ./configuration.nix
      ./hardware.nix
      ./services.nix
    ];
    disko_modules = [
      ./disko-config.nix
    ];
    features = [
      "containers"
    ];
    languages = [ ];
  };

in
{

  nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    inherit (host) system modules specialArgs;
  };
}

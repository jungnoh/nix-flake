{
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  ...
}@inputs:
let
  hostname = "pekora";
  host = import ../mkHost.nix {
    inherit hostname inputs;

    system = "aarch64-darwin";
    system_modules = [
      ./configuration.nix
    ];
    features = [ "personal" ];
  };

in
{
  darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
    inherit (host) system modules specialArgs;
  };
}

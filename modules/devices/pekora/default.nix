{
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  ...
}@inputs:
let
  host = import ../mkHost.nix {
    inherit inputs;

    system = "aarch64-darwin";
    system_modules = [
      ./configuration.nix
    ];
    features = [ "personal" ];
  };

in
{
  darwinConfigurations."pekora" = nix-darwin.lib.darwinSystem {
    inherit (host) system modules specialArgs;
  };
}

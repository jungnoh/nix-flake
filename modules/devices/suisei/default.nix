{
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  ...
}@inputs:
let
  hostname = "suisei";
  host = import ../mkHost.nix {
    inherit hostname inputs;

    system = "aarch64-darwin";
    system_modules = [
      ./configuration.nix
    ];
    features = [
      "work"
      "desktop"
      "dev-env"
    ];
    languages = [
      "rust"
      "golang"
      "node"
    ];
  };

in
{
  darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
    inherit (host) system modules specialArgs;
  };
}

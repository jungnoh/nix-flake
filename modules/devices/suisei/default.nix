{
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
      ./ollama.nix
      (import ../../packages/03-apps/tailscale.nix { })
    ];
    features = [
      "personal"
      "desktop"
      "dev-env"
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
  darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
    inherit (host) system modules specialArgs;
  };
}

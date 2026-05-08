inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "pekora";
  system = "aarch64-darwin";
  system_modules = [
    ./configuration.nix
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
}

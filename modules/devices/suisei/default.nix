inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "suisei";
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
}

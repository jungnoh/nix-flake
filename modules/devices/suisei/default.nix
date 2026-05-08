inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "suisei";
  system = "aarch64-darwin";
  system_modules = [
    ./configuration.nix
    ./ollama.nix
  ];
  features = [
    "personal"
    "desktop"
  ];
}

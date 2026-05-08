inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "taki";
  system = "x86_64-linux";
  username = "jungnoh";
  use_agenix = true;
  system_modules = [
    ./configuration.nix
    ./hardware.nix
  ];
  disko_modules = [
    ./disko-config.nix
  ];
  features = [
    "personal"
    "desktop"
    "dev-env"
    "kde"
    "games"
  ];
  languages = [
    "rust"
    "golang"
    "dotnet"
    "node"
  ];
}

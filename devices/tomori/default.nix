inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "tomori";
  system = "x86_64-linux";
  system_modules = [
    ./configuration.nix
    ./hardware.nix
  ];
}

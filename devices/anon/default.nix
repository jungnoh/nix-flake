inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "anon";
  system = "x86_64-linux";
  username = "user";
  system_modules = [
    ./configuration.nix
    ./hardware.nix
  ];
  disko_modules = [
    ./disko-config.nix
  ];
}

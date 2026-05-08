inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "soyo";
  system = "x86_64-linux";
  username = "jungnoh";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./disko-config.nix
  ]
  ++ (import ./services);

  myOptions = {
    virtualization.containers.enable = true;
    tailscale = {
      enable = true;
      routing = true;
      ssh = true;
    };
  };
}

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
    containers.enable = true;
    tailscale = {
      enable = true;
      useRouting = true;
      useSSH = true;
    };
  };
}

inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "soyo";
  system = "x86_64-linux";
  username = "jungnoh";
  use_agenix = true;
  system_modules = [
    ./configuration.nix
    ./hardware.nix
    (import ../../packages/03-apps/tailscale.nix {
      useRouting = true;
      useSSH = true;
    })
  ]
  ++ (import ./services);
  disko_modules = [
    ./disko-config.nix
  ];
  features = [
    "containers"
  ];
  languages = [ ];
}

inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "anon";
  system = "x86_64-linux";
  username = "user";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./disko-config.nix
  ];

  myOptions = {
    tailscale = {
      enable = true;
      routing = true;
      systray = true;
    };
    editors.vscode = {
      enable = true;
    };
  };
}

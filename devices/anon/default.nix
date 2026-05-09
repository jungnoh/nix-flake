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
    linux = {
      desktop = true;
      desktopEnv = "xfce";
    };
    git = {
      name = "";
      email = "";
    };
    tailscale = {
      enable = true;
      systray = true;
    };
    desktopApps = {
      tools = false;
    };
    editors.vscode.enable = true;
    virtualization.virt-manager.enable = true;
  };
}

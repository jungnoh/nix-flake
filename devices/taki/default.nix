inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "taki";
  system = "x86_64-linux";
  username = "jungnoh";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./disko-config.nix
  ];

  myOptions = {
    containers.enable = true;
    editors.zed.enable = true;
    mullvad.enable = true;
    tailscale = {
      enable = true;
      systray = true;
    };
    devtools = {
      enable = true;
      languages = {
        rust = true;
        golang = true;
        dotnet = true;
        node = true;
      };
    };
    desktopApps = {
      fun = true;
      work = true;
      games = true;
    };
  };
}

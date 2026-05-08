inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "tomori";
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
  ];

  myOptions = {
    virtualization.containers.enable = true;
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

inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "pekora";
  system = "aarch64-darwin";
  modules = [
    ./configuration.nix
  ];

  myOptions = {
    darwin.homebrew = true;
    editors.zed.enable = true;
    tailscale.enable = true;
    mullvad.enable = true;
    containers.enable = true;
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
    };
  };
}

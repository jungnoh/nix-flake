inputs:
import ../mkHost.nix {
  inherit inputs;

  hostname = "suisei";
  system = "aarch64-darwin";
  modules = [
    ./configuration.nix
    ./ollama.nix
  ];

  myOptions = {
    darwin.homebrew = true;
    editors.zed.enable = true;
    mullvad.enable = true;
    tailscale.enable = true;
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

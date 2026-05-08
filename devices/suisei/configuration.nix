{ pkgs, ... }:
{
  myOptions = {
    darwin.homebrew = true;
    mullvad.enable = true;
    tailscale.enable = true;
    devtools = {
      enable = true;
      langauges = {
        rust = true;
        golang = true;
        dotnet = true;
        node = true;
      };
    };
    editors = {
      zed.enable = true;
    };
    desktopApps = {
      fun = true;
      work = true;
    };
  };

  environment = {
    systemPackages = [ pkgs.vim ];
    systemPath = [
      "~/go/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  services.openssh.enable = true;
}

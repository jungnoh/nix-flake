{ pkgs, ... }:
{
  myOptions = {
    darwin.homebrew = true;
    tailscale.enable = true;
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
    editors = {
      zed.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      vim
    ];
    systemPath = [
      "~/go/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  homebrew.casks = [
    "utm"
    "wireshark"
  ];
}

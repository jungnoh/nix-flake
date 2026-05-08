{ pkgs, ... }:
{
  myOptions.darwin.homebrew = true;
  myOptions.tailscale.enable = true;

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

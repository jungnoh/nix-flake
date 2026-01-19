{
  pkgs,
  lib,
  config,
  ctx,
  ...
}@inputs:
let
  inherit (ctx) username;
in
{
  environment = {
    systemPackages = [ pkgs.vim ];
    systemPath = [
      "/opt/homebrew/bin"
      "~/go/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.primaryUser = username;

  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    finder = {
      _FXShowPosixPathInTitle = true; # show full path in finder title
      AppleShowAllExtensions = true; # show all file extensions
      FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
      QuitMenuItem = true; # enable quit menu item
      ShowPathbar = true; # show path bar
      ShowStatusBar = true; # show status bar
    };
    dock = {
      autohide = true;
      show-recents = false; # disable recent apps
    };
  };
}

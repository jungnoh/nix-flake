{
  lib,
  config,
  ctx,
  ...
}@inputs:
let
  inherit (ctx) hostname username;
  myOptions = config.myOptions;
in
with lib;
{
  options.myOptions.darwin = {
    homebrew = mkOption {
      type = types.bool;
      default = false;
      description = "Enable homebrew";
    };
  };

  config = mkIfDarwin myOptions.enable {
    # Set Git commit hash for darwin-version.
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    ## Homebrew
    homebrew = mkIf myOptions.darwin.homebrew {
      enable = true;
      prefix = "/opt/homebrew";
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      global.brewfile = true;

      extraConfig = ''
        cask_args require_sha: true
      '';

      taps = [ ];
    };
    environment = {
      variables.HOMEBREW_NO_ANALYTICS = mkIf myOptions.darwin.homebrew "1";
      systemPath = mkIf myOptions.darwin.homebrew [ "/opt/homebrew/bin" ];
      pathsToLink = [ "/Applications" ];
    };

    ## macOS Config
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

    ## Networking
    # TODO: This may be different by device?
    networking.knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    networking.dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    networking.hostName = hostname;
    networking.localHostName = hostname;
    networking.computerName = hostname;
  };
}

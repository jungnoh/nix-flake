{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    # Initialize Homebrew Casks
    homebrew = {
      enable = true;
      brewPrefix = "/opt/homebrew/bin";
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      global = {
        brewfile = true;
        lockfiles = true;
      };

      extraConfig = ''
        cask_args require_sha: true
      '';

      taps = [ ];
    };

    environment.variables.HOMEBREW_NO_ANALYTICS = "1";
    environment.systemPath = [ "/opt/homebrew/bin" ];
  };
}

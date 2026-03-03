{
  ...
}:
{
  config = {
    # Initialize Homebrew Casks
    homebrew = {
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

    environment.variables.HOMEBREW_NO_ANALYTICS = "1";
    environment.systemPath = [ "/opt/homebrew/bin" ];
  };
}

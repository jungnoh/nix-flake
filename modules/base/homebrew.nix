{ pkgs, lib, config, ... }:
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

      taps = [
        "homebrew/services"
      ];
    };

    env.HOMEBREW_NO_ANAYTICS = "1";
    env.PATH = [ "/opt/homebrew/bin" ];
  };
}

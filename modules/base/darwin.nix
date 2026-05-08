{
  inputs,
  config,
  ctx,
  ...
}:
let
  inherit (inputs) lib;
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

  config = mkIf (myOptions.enable && ctx.isDarwin) {
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
    environment.variables.HOMEBREW_NO_ANALYTICS = mkIf myOptions.darwin.homebrew "1";
    environment.systemPath = mkIf myOptions.darwin.homebrew [ "/opt/homebrew/bin" ];

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
    networking.hostName = ctx.hostname;
    networking.localHostName = ctx.hostname;
    networking.computerName = ctx.hostname;
  };
}

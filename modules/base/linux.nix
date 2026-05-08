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
  options.myOptions.linux = {
    desktop = mkOption {
      type = types.bool;
      default = false;
      description = "Enable configuration for desktop environments.";
    };
    i18nSupport = mkOptions {
      type = types.bool;
      default = true;
      description = "Enable Korean/Japanese inputs and fonts. Only effective on desktop environments.";
    };
  };

  config = mkIf (myOptions.enable && ctx.isLinux) {
    time.timeZone = myOptions.timezone;
  };
}

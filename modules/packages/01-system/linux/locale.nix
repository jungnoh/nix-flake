{
  config,
  pkgs,
  ctx,
  ...
}:
let
  locale = "en_US";
in
{
  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultCharset = "UTF-8";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };
}

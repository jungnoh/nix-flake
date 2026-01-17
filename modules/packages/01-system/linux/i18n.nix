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

  # https://github.com/Riey/kime
  i18n.inputMethod = {
    enable = true;
    type = "kime";
    kime.iconColor = "White";
  };

  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    pretendard-jp
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Pretendard JP" ];
      sansSerif = [ "Pretendard JP" ];
      monospace = [ "Noto Sans Mono" ];
    };
  };
}

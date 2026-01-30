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
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-hangul
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "hangul";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "hangul";
          };
          "Groups/0/Items/2" = {
            Name = "mozc";
          };
          GroupOrder = {
            "0" = "Default";
          };
        };
      };
    };
  };
  home.packages = with pkgs; [
    kdePackages.fcitx5-configtool
  ];

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

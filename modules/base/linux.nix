{
  lib,
  config,
  ctx,
  ...
}:
let
  inherit (ctx) hostname;
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
    desktopEnv = mkOption {
      type = types.enum [
        "xfce"
        "kde"
      ];
      default = "kde";
    };
  };

  config = mkIfLinux myOptions.enable (mkMerge [
    {
      time.timeZone = myOptions.timezone;
      networking.hostName = hostname;
      networking.nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];

      ## Basic utilities for Linux

      ## i18n options to set in servers as well
      i18n.defaultCharset = "UTF-8";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings.LC_ALL = "en_US.UTF-8";
    }
    (mkIf myOptions.linux.desktop {
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
        xclip
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

      home.shellAliases = {
        pbcopy = "xclip -selection clipboard";
        pbpaste = "xclip -selection clipboard -o";
      };
    })
  ]);
}

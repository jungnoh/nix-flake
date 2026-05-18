# Common applications that are used in a desktop environment
{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  webBrowserApps = byPlatform {
    common = {
      home.packages = with pkgs; [
        google-chrome
      ];
    };
    linux = {
      programs.firefox.enable = true;
    };
  };

  toolApps = byPlatform {
    common = {
      myOptions.ghostty.enable = true;
    };
    darwin = {
      home.packages = with pkgs; [
        betterdisplay
        localsend
      ];
      homebrew.casks = [
        "keka"
        "fuwari"
        "1password"
      ];
      homebrew.masApps = {
        "Magnet" = 441258766;
        "Amphetemine" = 937984704;
      };
    };
    linux = {
      programs.localsend.enable = true;
      home.packages = with pkgs; [
        parted
        _1password-gui
        (mpv.override {
          youtubeSupport = false;
          scripts = [
            mpvScripts.uosc
            mpvScripts.thumbfast
          ];
        })
      ];
    };
  };

  funApps = byPlatform {
    common = {
      home.packages = with pkgs; [
        protonmail-desktop
        telegram-desktop
        spotify
        moonlight-qt
        anki-bin
        discord
      ];
    };
    darwin = {
      homebrew.masApps = {
        "KakaoTalk" = 869223134;
      };
    };
  };

  workApps = byPlatform {
    common = {
      home.packages = with pkgs; [
        obsidian
        protonmail-desktop
      ];
    };
    darwin = {
      homebrew.casks = [ "claude" ];
      homebrew.masApps = {
        "KakaoTalk" = 869223134;
        "한컴오피스 한글 Viewer" = 416746898;
      };
      home.packages = with pkgs; [ notion-app ];
    };
  };

  gameApps = byPlatform {
    linux = {
      programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      environment.systemPackages = with pkgs; [
        # Install dw-proton
        protonplus
      ];
    };
  };

  isDesktop = (isLinux && config.myOptions.linux.desktop) || isDarwin;
  desktopApps = config.myOptions.desktopApps;
in
{
  options.myOptions.desktopApps = with lib; {
    webBrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Install web browsers";
    };
    tools = mkOption {
      type = types.bool;
      default = true;
      description = "Install utility apps";
    };
    fun = mkOption {
      type = types.bool;
      default = false;
      description = "Install apps for fun";
    };
    work = mkOption {
      type = types.bool;
      default = false;
      description = "Install apps for productivity";
    };
    games = mkOption {
      type = types.bool;
      default = false;
      description = "Install apps for games";
    };
  };

  config = mkIf isDesktop (mkMerge [
    (mkIf desktopApps.webBrowser webBrowserApps)
    (mkIf desktopApps.tools toolApps)
    (mkIf desktopApps.fun funApps)
    (mkIf desktopApps.work workApps)
    (mkIf desktopApps.games gameApps)
  ]);
}

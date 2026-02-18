# See https://nixos.wiki/wiki/KDE
{
  lib,
  config,
  pkgs,
  ctx,
  inputs,
  ...
}:
let
  inherit (ctx) username;
  inherit (inputs) plasma-manager;
in
#
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.kdepim-runtime
    kdePackages.kmahjongg
    kdePackages.kmines
    kdePackages.konversation
    kdePackages.kpat
    kdePackages.ksudoku
    kdePackages.ktorrent
    mpv
  ];

  home.sharedModules = [ plasma-manager.homeModules.plasma-manager ];

  home.programs.plasma = {
    enable = true;
    powerdevil.AC = {
      autoSuspend.action = "nothing";
      dimDisplay.enable = false;
      powerButtonAction = "nothing";
      powerProfile = "performance";
      turnOffDisplay.idleTimeout = "never";
    };
    workspace = {
      colorScheme = "BreezeDark";
    };
    panels = [
      {
        location = "top";
        height = 26;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              date.position = "besideTime";
              time.format = "24h";
              time.showSeconds = "never";
              font = {
                family = "Pretendard JP Medium";
                size = 9;
              };
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.mediacontroller"
          {
            systemTray = {
              items.hidden = [
                "chrome_status_icon_1" # Cursor
                "spotify-client"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.mediacontroller"
              ];
            };
          }
        ];
      }
      {
        location = "bottom";
        alignment = "center";
        floating = true;
        lengthMode = "fit";
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }
        ];
      }
    ];
  };
}

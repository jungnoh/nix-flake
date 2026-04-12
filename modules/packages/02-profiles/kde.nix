# See https://nixos.wiki/wiki/KDE
{
  pkgs,
  inputs,
  ...
}:
let
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
    kdePackages.konsole
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
    kscreenlocker = {
      autoLock = false;
      passwordRequired = true;
      passwordRequiredDelay = null;
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
        lengthMode = "fill";
        floating = false;
        height = 32;
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:com.mitchellh.ghostty.desktop"
                "applications:google-chrome.desktop"
                "applications:obsidian.desktop"
                "applications:dev.zed.Zed.desktop"
              ];
            };
          }
        ];
      }
    ];
  };
}

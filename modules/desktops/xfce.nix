{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  enable =
    lib.isLinux && config.myOptions.linux.desktop && config.myOptions.linux.desktopEnv == "xfce";
in
lib.mkIfLinux enable {
  displayManager.defaultSession = "xfce";
  xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager = {
      defaultSession = "xfce";
      lightdm.enable = true;
    };

    # Configure keymap in X11
    xkb = {
      layout = "kr";
      variant = "";
    };
  };
}

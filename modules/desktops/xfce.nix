{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable =
    lib.isLinux && config.myOptions.linux.desktop && config.myOptions.linux.desktopEnv == "xfce";
in
lib.mkIfLinux enable {
  environment.systemPackages = with pkgs; [
    xdriinfo
    xrandr
  ];
  services.displayManager.defaultSession = "xfce";
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "kr";
      variant = "";
    };
  };
}

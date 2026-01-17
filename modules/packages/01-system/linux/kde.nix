# See https://nixos.wiki/wiki/KDE
{
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
}

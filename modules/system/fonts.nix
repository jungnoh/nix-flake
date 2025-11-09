{ config, lib, pkgs, ... }:
{
  config = {
    fonts.packages = with pkgs.unstable; [
      meslo-lgs-nf
      pretendard
      pretendard-jp
      font-awesome
      roboto
      source-sans
      source-sans-pro
    ];
  };
}

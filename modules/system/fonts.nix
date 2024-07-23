{ config, lib, pkgs, ... }:
{
  config = {
    fonts.packages = with pkgs; [
      meslo-lgs-nf
      pretendard
      pretendard-jp
    ];
  };
}
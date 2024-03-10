{ config, lib, pkgs, ... }:
{
	config = {
		fonts.fontDir.enable = true;
		fonts.fonts = with pkgs; [
      meslo-lgs-nf
			pretendard
			pretendard-jp
		];
	};
}
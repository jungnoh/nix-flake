{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [direnv];
  home.programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = { global.load_dotenv = true; };
  };
}

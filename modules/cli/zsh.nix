{ config, lib, pkgs, ... }:
{
  home.programs = {
    thefuck = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      shellAliases = {
        awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "kubectl" "dotenv"];
      };
    };
  };
}

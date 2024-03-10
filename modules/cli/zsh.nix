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
        vaultlogin = "vault login -method=oidc";
        # Terraform
        tf = "terraform";
        tfa = "terraform apply";
        tfp = "terraform plan";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "kubectl" "dotenv"];
      };
    };
  };
}

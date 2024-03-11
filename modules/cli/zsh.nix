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
      initExtraFirst = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      shellAliases = {
        awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
        vaultlogin = "vault login -method=oidc";
        # Terraform
        tf = "terraform";
        tfa = "terraform apply";
        tfp = "terraform plan";
        # Kubectl
        k = "kubectl";
        kg = "kubectl get";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "bigH/git-fuzzy"; tags = ["as:command" "use:\"bin/git-fuzzy\""]; }
          { name = "romkatv/powerlevel10k"; tags = ["as:theme" "depth:1"]; }
        ];
      };
    };
  };
  home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
}

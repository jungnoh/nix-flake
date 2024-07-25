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
      export KUBE_EDITOR=vim
      export K9S_EDITOR=vim
      export EDITOR=vim
      source ~/.p10k.zsh
      source ~/.hooks.zsh
      '';
      initExtra = ''
      [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh
      [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh
      export PATH=$PATH:~/.cargo/bin
      export AWS_PROFILE=saml
      export VAULT_ADDR=https://vault.devsisters.cloud
      export PATH=$PATH:/Applications/Wireshark.app/Contents/MacOS

      alias vaultctx=~/.vaultctx/script

      function load_vault_envs() {
        export VAULT_ADDR=$(vaultctx get-addr)
      }

      typeset -a precmd_functions
      precmd_functions+=(load_vault_envs)

      . $(brew --prefix asdf)/libexec/asdf.sh
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
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
    };
  };
  home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
  home.file.".hooks.zsh".text = (builtins.readFile ./hooks.zsh);
}

{ config, lib, pkgs, ... }:
{
  home.programs = {
    thefuck = {
      enable = true;
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    ripgrep = { enable = true; };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      initExtraFirst = ''
        export KUBE_EDITOR=vim
        export K9S_EDITOR=vim
        export EDITOR=vim
        source ~/.p10k.zsh
      '';
      initExtra = ''
        [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh
        [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh
        export PATH=$PATH:/Applications/Wireshark.app/Contents/MacOS:$HOME/.dotnet/tools:$HOME/.istioctl/bin:$HOME/.cargo/bin

        function load_vault_envs() {
          export VAULT_ADDR=$(vaultctx get-addr)
        }

        typeset -a precmd_functions
        precmd_functions+=(load_vault_envs)
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
        # Tools
        cat = "bat --style=plain";
        vaultctx = "~/.vaultctx/script";
      };
      sessionVariables = {
        AWS_PROFILE = "saml";
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
}

{ config, lib, pkgs, ... }:
let
  kubectlAliasRepo = pkgs.fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-aliases";
    rev = "ac5bfb00a1b351e7d5183d4a8f325bb3b235c1bd";
    sha256 = "sha256-X2E0n/U8uzZ/JAsYIvPjnEQLri8A7nveMmbkOFSxO5s=";
  };
  kubectlAlias = "${kubectlAliasRepo}/.kubectl_aliases";

  tfAliasRepo = pkgs.fetchFromGitHub {
    owner = "zer0beat";
    repo = "terraform-aliases";
    rev = "d290b425b3db59266cea4e40dc630fcc6b3bf624";
    sha256 = "sha256-rXU8UpseQgqsljOfHBcd84aoRL82TT7cfbRmaJQULk8=";
  };
  tfAlias = "${tfAliasRepo}/.terraform_aliases";

  extraPaths = [
    "/Applications/Wireshark.app/Contents/MacOS"
    "$HOME/.dotnet/tools"
    "$HOME/.istioctl/bin"
    "$HOME/.cargo/bin"
  ];
in
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
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      dotDir = ".config/zsh";

      initExtraFirst = ''
        source ~/.p10k.zsh
      '';
      initExtra = ''
        source "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
        autoload -Uz bashcompinit && bashcompinit
        source "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"

        export PATH=$PATH:${lib.strings.concatStringsSep ":" extraPaths}

        source ${kubectlAlias}
        source ${tfAlias}

        function load_vault_envs() {
          export VAULT_ADDR=$(vaultctx get-addr)
        }

        typeset -a precmd_functions
        precmd_functions+=(load_vault_envs)
      '';
      shellAliases = {
        awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
        vaultlogin = "vault login -method=oidc";

        # Tools
        cat = "bat --style=plain";
        vaultctx = "~/.vaultctx/script";
      };
      sessionVariables = {
        AWS_PROFILE = "saml";
        KUBE_EDITOR = "vim";
        K9S_EDITOR = "vim";
        EDITOR = "vim";

        # See https://stackoverflow.com/q/74895147
        DOTNET_ROOT = "${pkgs.unstable.dotnet-sdk_9}/share/dotnet";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
      };
    };
  };
  home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
}

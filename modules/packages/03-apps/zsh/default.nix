{
  config,
  lib,
  pkgs,
  ...
}:
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
in
{
  home.programs = {
    pay-respects = {
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
    ripgrep = {
      enable = true;
    };
    eza = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
    navi = {
      enable = true;
    };

    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      # dotDir = "${homeDir}/.config/zsh";

      initContent = ''
        source ~/.p10k.zsh
        autoload -Uz bashcompinit && bashcompinit

        source ${kubectlAlias}
        source ${tfAlias}
      '';

      shellAliases = {
        cat = "bat --style=plain";
      };

      sessionVariables = {
        EDITOR = "vim";
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
        plugins = [ "git" ];
      };
    };
  };
  home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
}

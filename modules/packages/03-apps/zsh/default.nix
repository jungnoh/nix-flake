{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyLinux;
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
lib.mkMerge [
  (onlyLinux {
    users.defaultUserShell = pkgs.unstable.zsh;
  })
  {
    home.programs = {
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
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
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

        initContent = lib.mkMerge [
          # Enable instant prompt at the very start (before anything else)
          (lib.mkBefore ''
            if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
          '')
          ''
            source ~/.p10k.zsh

            # Lazy-load kubectl aliases (only loaded on first kubectl invocation)
            function kubectl() {
              unfunction kubectl
              source ${kubectlAlias}
              kubectl "$@"
            }

            # Lazy-load terraform aliases (only loaded on first tf invocation)
            function terraform() {
              unfunction terraform
              source ${tfAlias}
              terraform "$@"
            }
            alias tf='terraform'
          ''
        ];

        shellAliases = {
          cat = "bat --style=plain";
          # Common git aliases (replacing oh-my-zsh git plugin)
          g = "git";
          ga = "git add";
          gaa = "git add --all";
          gb = "git branch";
          gc = "git commit";
          gcm = "git commit -m";
          gco = "git checkout";
          gd = "git diff";
          gf = "git fetch";
          gl = "git pull";
          gp = "git push";
          gst = "git status";
          glg = "git log --oneline --decorate --graph";
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
      };
    };
    home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
  }
]

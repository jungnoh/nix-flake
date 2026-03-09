{
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyLinux;
in
lib.mkMerge [
  (onlyLinux {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
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
      starship = {
        enable = true;
      };

      zsh = {
        enable = true;
        autosuggestion = {
          enable = true;
        };
        enableCompletion = true;

        initContent = ''
          eval "$(starship init zsh)"
          # asdf
          export PATH="''${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

          alias tf='terraform'
        '';

        shellAliases = {
          cat = "bat --style=plain";
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
          glg = "git log --decorate --graph";
        };

        sessionVariables = {
          EDITOR = "vim";
        };
      };
    };
  }
]

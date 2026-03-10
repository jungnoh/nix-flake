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

      eza = {
        enable = true;
        enableZshIntegration = true;
      };

      ripgrep.enable = true;
      navi.enable = true;
      starship = {
        enable = true;
        settings = fromTOML (builtins.readFile ./starship.toml);
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;

        zplug = {
          enable = true;
          plugins = [
            { name = "olets/zsh-transient-prompt"; }
          ];
        };

        initContent = ''
          # Transient prompt for starship. See https://github.com/starship/starship/issues/888#issuecomment-3597694479
          eval "$(starship init zsh)"
          TRANSIENT_PROMPT_PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="$${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="$${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="$${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
          TRANSIENT_PROMPT_RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="$${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="$${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="$${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
          TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(starship module character)'

          # asdf
          export PATH="''${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
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
          tf = "terraform";
        };

        sessionVariables = {
          EDITOR = "vim";
        };
      };
    };
  }
]

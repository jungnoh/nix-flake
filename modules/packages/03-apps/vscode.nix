{
  pkgs,
  lib,
  config,
  ...
}:
let
  vimHandleKeys = lib.onlyLinux {
    "<C-a>" = false;
    "<C-c>" = false;
    "<C-f>" = false;
    "<C-v>" = false;
    "<C-x>" = false;
  };
  smallTabLanguages = [
    "nix"
    "javascript"
    "typescript"
    "javascriptreact"
    "typescriptreact"
    "html"
    "json"
  ];
  smallTabOptions = builtins.foldl' (
    acc: lang:
    acc
    // {
      "[${lang}]" = {
        "editor.tabSize" = 2;
      };
    }
  ) { } smallTabLanguages;
in
with lib;
{
  options.myOptions.editors.vscode = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.myOptions.editors.vscode.enable {
    home.programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Basics
          editorconfig.editorconfig
          vscodevim.vim
          christian-kohler.path-intellisense
          # Themes
          dracula-theme.theme-dracula
          pkief.material-icon-theme
          teabyii.ayu
          # Markdown
          yzhang.markdown-all-in-one
          # Nix
          bbenoist.nix
          arrterian.nix-env-selector
          # Terraform
          hashicorp.terraform
          # Rust
          rust-lang.rust-analyzer
          # Go
          golang.go
          # TS/etc.
          dbaeumer.vscode-eslint
          bradlc.vscode-tailwindcss
          tamasfe.even-better-toml
        ];
        userSettings = {
          "window.commandCenter" = true;
          "workbench.colorTheme" = "Monokai Dimmed";
          "vim.handleKeys" = vimHandleKeys;
        }
        // smallTabOptions;
      };
    };
  };
}

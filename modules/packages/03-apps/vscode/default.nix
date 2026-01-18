{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyLinux;
  vimHandleKeys = onlyLinux {
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
{
  config = {
    home.programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
          # Basics
          editorconfig.editorconfig
          vscodevim.vim
          christian-kohler.path-intellisense
          # Themes
          dracula-theme.theme-dracula
          pkief.material-icon-theme
          teabyii.ayu
          # AI Agents
          anthropic.claude-code
          kilocode.kilo-code
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
        ];
        userSettings = {
          "window.commandCenter" = true;
          "workbench.colorTheme" = "Ayu Dark Bordered";
          "vim.handleKeys" = vimHandleKeys;
        }
        // smallTabOptions;
      };
    };
  };
}

{ config, lib, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ vscode ];
    home.programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        extensions = with pkgs.unstable.vscode-extensions; [
          # Language Supports
          golang.go                     # Go
          bbenoist.nix                  # Nix
          ms-python.python              # Python
          rust-lang.rust-analyzer       # Rust
          hashicorp.terraform           # Terraform
          tamasfe.even-better-toml      # TOML
          redhat.vscode-yaml            # YAML
          # Vim
          vscodevim.vim
          # Theme
          jdinhlife.gruvbox
          vscode-icons-team.vscode-icons
          # Copilot
          github.copilot
          # github.copilot-chat
          # Git
          eamodio.gitlens
        ];
        userSettings = {
          "window.zoomLevel" = 1;
          "workbench.colorTheme" = "Gruvbox Dark Hard";
          "workbench.iconTheme" = "vscode-icons";
        };
      };
    };
  };
}

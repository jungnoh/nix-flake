{ config, lib, pkgs, ... }:
{
  config = {
    home.programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        extensions = with pkgs.vscode-extensions; [
          # Vim
          vscodevim.vim
          # Rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          # Python
          ms-python.python
          # Go
          golang.go
          # Copilot
          github.copilot
          github.copilot-chat
          # Nix
          bbenoist.nix
        ];
      };
    };
  };
}

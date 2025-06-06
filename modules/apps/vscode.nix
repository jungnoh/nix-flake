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
          golang.go # Go
          bbenoist.nix # Nix
          ms-python.python # Python
          rust-lang.rust-analyzer # Rust
          hashicorp.terraform # Terraform
          tamasfe.even-better-toml # TOML
          redhat.vscode-yaml # YAML
          tim-koehler.helm-intellisense # Helm
          ms-kubernetes-tools.vscode-kubernetes-tools # Kubernetes
          # Vim
          vscodevim.vim
          # Theme
          jdinhlife.gruvbox
          vscode-icons-team.vscode-icons
          # Copilot
          github.copilot
          # Git
          eamodio.gitlens
          # Markdown
          yzhang.markdown-all-in-one
          # ESLint
          dbaeumer.vscode-eslint
          # Prettier
          esbenp.prettier-vscode
          # Protobuf
          zxh404.vscode-proto3
          # Tailwind CSS
          bradlc.vscode-tailwindcss
          # Deno
          denoland.vscode-deno
          # C/C++ & Toolchains
          ms-vscode.cpptools-extension-pack
          ms-vscode.cmake-tools
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "markdown-footnotes";
            publisher = "bierner";
            version = "0.1.1";
            sha256 = "sha256-h/Iyk8CKFr0M5ULXbEbjFsqplnlN7F+ZvnUTy1An5t4=";
          }
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "prisma";
            publisher = "Prisma";
            version = "6.2.1";
            sha256 = "sha256-5dQ7K234IAWIP4V91XqlqoQqgmdB45Br/sW2huZlyOQ=";
          }
        ];
        userSettings = {
          "window.zoomLevel" = 1;
          "workbench.colorTheme" = "Gruvbox Dark Hard";
          "workbench.iconTheme" = "vscode-icons";
          "rust-analyzer.procMacro.enable" = true;
        };
      };
    };
  };
}

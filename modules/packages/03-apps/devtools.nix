{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  devtoolOptions = config.myOptions.devtools;

  configMap = {
    common = {
      home.packages = with pkgs; [
        asdf-vm
        jetbrains-toolbox
        brotli
        cloc
        nil
        sqlitebrowser
        insomnia
        just
        gnumake
      ];
    };
    ai = {
      home.packages =
        (with pkgs; [
          opencode
        ])
        ++ (with pkgs.master; [
          claude-code
        ]);
    };
    cloud = {
      home.packages = with pkgs; [
        # AWS
        awscli2
        saml2aws
        # GCP
        google-cloud-sdk
        # Azure
        azure-cli
      ];
      home.sessionVariables = {
        AWS_PROFILE = "saml";
      };
    };
    kubernetes = {
      home.packages = with pkgs; [
        # Kubernetes
        kubectl
        krew
        kubectx
        kubernetes-helm
        kustomize
        k9s
        istioctl
        minikube
      ];
      home.sessionVariables = {
        KUBE_EDITOR = "vim";
        K9S_EDITOR = "vim";
      };
      home.sessionPath = [
        "$HOME/.istioctl/bin"
      ];
    };
  };

  langMap = {
    rust = {
      home.packages = with pkgs; [
        rustup
        cargo-binstall
      ];
      home.sessionPath = [
        "$HOME/.cargo/bin"
      ];
    };
    golang = {
      home.packages = with pkgs; [
        go
        go-migrate
      ];
    };
    dotnet = {
      home.packages = with pkgs; [
        dotnet-sdk_10
      ];
      home.sessionVariables = {
        # See https://stackoverflow.com/q/74895147
        DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
      };
      home.sessionPath = [
        "$HOME/.dotnet/tools"
      ];
    };
    node = {
      home.packages = with pkgs; [
        nodejs
        pnpm
        yarn
      ];
    };
  };
in
{
  options.myOptions.devtools = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    common = mkOption {
      type = types.bool;
      default = true;
    };
    ai = mkOption {
      type = types.bool;
      default = true;
    };
    cloud = mkOption {
      type = types.bool;
      default = true;
    };
    kubernetes = mkOption {
      type = types.bool;
      default = true;
    };
    languages = {
      rust = mkOption {
        type = types.bool;
        default = false;
      };
      golang = mkOption {
        type = types.bool;
        default = false;
      };
      dotnet = mkOption {
        type = types.bool;
        default = false;
      };
      node = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf devtoolOptions.enable (mkMerge [
    (mkIf devtoolOptions.ai configMap.ai)
    (mkIf devtoolOptions.common configMap.common)
    (mkIf devtoolOptions.cloud configMap.cloud)
    (mkIf devtoolOptions.kubernetes configMap.kubernetes)
    (mkIf devtoolOptions.languages.rust langMap.rust)
    (mkIf devtoolOptions.languages.golang langMap.golang)
    (mkIf devtoolOptions.languages.dotnet langMap.dotnet)
    (mkIf devtoolOptions.languages.node langMap.node)
  ]);
}

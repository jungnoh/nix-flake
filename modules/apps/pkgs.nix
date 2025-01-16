{ config, lib, pkgs, pkgs-unstable, ... }:
let
  toolPkgs = with pkgs.unstable; [
    # Kubernetes
    kubectl
    krew
    kubectx
    kubernetes-helm
    kustomize
    k9s
    # Kubernetes Ecosystem
    argo-rollouts
    minikube
    # Containers
    colima
    lima
    docker
    docker-compose
    # Databases
    redis
    # Cloud
    vault
  ];
  cliPkgs = with pkgs.unstable; [
    # Tools
    btop
    htop
    fd
    tmux
    # Serialization
    jq
    yq
    # Media
    ffmpeg
    imagemagick
    exiftool
    # Network
    wget
    grpcurl
    mtr
    # Other
    pv
    brotli
  ];
  languagePkgs = with pkgs.unstable; [
    # Node and others
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    deno
    # Rust
    rustup
    # Python
    python3
    virtualenv
    pipx
    # Go
    go
    go-migrate
    # .NET
    dotnet-sdk_9
    # Java
    visualvm
  ];
  cloudSdkPkgs = with pkgs.unstable; [
    # AWS
    awscli2
    saml2aws
    # Azure
    google-cloud-sdk
    # GCP
    azure-cli
    # Cloudflare
    wrangler
  ];
  libPkgs = with pkgs; [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];
in
{
  config = {
    home.packages = (with pkgs; [
    ]) ++ cliPkgs ++ toolPkgs ++ cloudSdkPkgs ++ languagePkgs;
  };
}

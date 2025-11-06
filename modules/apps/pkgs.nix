{ config, lib, pkgs, pkgs-unstable, ... }:
let
  toolPkgs = (with pkgs.unstable; [
    # Kubernetes
    kubectl
    krew
    kubectx
    kubernetes-helm
    kustomize
    k9s
    # Kubernetes Ecosystem
    minikube
    # Containers
    colima
    lima
    docker
    docker-compose
    # Packages
    asdf-vm
    protobuf
  ]) ++ (with pkgs; [
    # Databases
    redis
    # Cloud
    vault
  ]);
  cliPkgs = with pkgs.unstable; [
    # Tools
    btop
    htop
    mactop
    fd
    tmux
    devenv
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
    dogdns
    aria2
    # Other
    pv
    brotli
    cloc
  ];
  languagePkgs = with pkgs.unstable; [
    # Node and others
    deno
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    # Rust
    rustup
    cargo-binstall
    # Python
    python3
    virtualenv
    pipx
    uv
    # Go
    go
    go-migrate
    # .NET
    dotnet-sdk_9
  ];
  cloudSdkPkgs = with pkgs.unstable; [
    # AWS
    awscli2
    saml2aws
    # Azure
    google-cloud-sdk
    # GCP
    azure-cli
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

{
  config,
  lib,
  pkgs,
  ...
}:
let
  toolPkgs =
    (with pkgs.unstable; [
      # Development Tools
      claude-code

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
    ])
    ++ (with pkgs; [
      # Databases
      redis
      # Cloud
      vault
    ]);
  cliPkgs = with pkgs.unstable; [
    # Tools
    devenv
    # Media
    ffmpeg
    imagemagick
    exiftool
    # Other
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
    # Go
    go
    go-migrate
    # .NET
    dotnet-sdk_9
  ];
in
{
  config = {
    home.packages = cliPkgs ++ toolPkgs ++ languagePkgs;
  };
}

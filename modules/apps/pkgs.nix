{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    home.packages = with pkgs; [
      awscli2
      saml2aws
      btop htop
      chafa
      fd
      ffmpeg
      fzf
      imagemagick
      jq
      kubectl
      kubectx
      kubernetes-helm
      nodejs
      nodePackages.pnpm
      nodePackages.yarn
      python311
      pv
      ripgrep
      thefuck
      tmux
      virtualenv
      wget
      yq
      k9s
      grpcurl
      go
      rustup
      vault
    ];
  };
}

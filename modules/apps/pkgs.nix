{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    home.packages = with pkgs; [
      awscli
      saml2aws
      btop
      chafa
      fd
      ffmpeg
      fzf
      imagemagick
      jq
      kubectl
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
    ];
  };
}

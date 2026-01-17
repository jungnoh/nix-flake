# Tools needed specifically for cloud/DevOps work
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    home.packages = with pkgs.unstable; [
      # Kubernetes
      kubectl
      krew
      kubectx
      kubernetes-helm
      kustomize
      k9s
      istioctl
      minikube
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
      KUBE_EDITOR = "vim";
      K9S_EDITOR = "vim";
    };
    home.sessionPath = [
      "$HOME/.istioctl/bin"
    ];
  };
}

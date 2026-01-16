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
      minikube
      # AWS
      awscli2
      saml2aws
      # GCP
      google-cloud-sdk
      # Azure
      azure-cli
      # Other stuff
      vault
    ];
  };
}

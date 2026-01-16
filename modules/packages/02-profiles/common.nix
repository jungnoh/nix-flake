# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    home.packages = with pkgs.unstable; [
      # Tools
      btop
      htop
      fd
      tmux
      # Serialization
      jq
      yq
      # Network
      curl
      wget
      grpcurl
      mtr
      # Other
      aria2
      pv
      # Python
      python3
      virtualenv
      pipx
      uv
    ];
  };
}

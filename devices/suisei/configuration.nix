{ pkgs, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  services.openssh.enable = true;
}

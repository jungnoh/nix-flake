{ pkgs, lib, config, ... }:
{
  config = {
    nix.settings.experimental-features = "nix-command flakes";
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}

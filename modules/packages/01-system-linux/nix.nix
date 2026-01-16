{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}

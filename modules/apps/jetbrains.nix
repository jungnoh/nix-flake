{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.rider
    ];
  };
}

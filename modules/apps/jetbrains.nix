{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.rust-rover
    ];
  };
}

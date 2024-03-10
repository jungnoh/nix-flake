{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.rust-rover
    ];
  };
}

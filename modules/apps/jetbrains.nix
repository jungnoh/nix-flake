{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [
      jetbrains-toolbox
    ];
  };
}

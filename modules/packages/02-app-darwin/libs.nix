{
  config,
  lib,
  pkgs,
  ...
}:
let
  darwinPkgs = with pkgs.unstable; [
    libiconv
  ];
in
{
  config = {
    home.packages = darwinPkgs;
  };
}

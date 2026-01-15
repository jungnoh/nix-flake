{ config, lib, pkgs, pkgs-unstable, ... }:
let
  darwinPkgs = with pkgs-unstable; [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];
in
{
  config = {
    home.packages = darwinPkgs;
  };
}

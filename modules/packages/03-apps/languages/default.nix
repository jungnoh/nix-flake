{ languages }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgRust = {
    home.packages = with pkgs.unstable; [
      rustup
      cargo-binstall
    ];
  };
  cfgGo = {
    home.packages = with pkgs.unstable; [
      go
      go-migrate
    ];
  };
  cfgDotnet = {
    home.packages = with pkgs.unstable; [
      dotnet-sdk_9
    ];
  };
  cfgNode = {
    home.packages = with pkgs.unstable; [
      deno
      nodejs
      nodePackages.pnpm
      nodePackages.yarn
    ];
  };

  cfgMap = {
    rust = cfgRust;
    golang = cfgGo;
    dotnet = cfgDotnet;
    node = cfgNode;
  };

  configs = builtins.map (p: cfgMap."${p}") languages;
in
{
  config = lib.mkMerge configs;
}

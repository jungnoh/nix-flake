{ languages }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgRust = {
    home.packages = with pkgs; [
      rustup
      cargo-binstall
    ];
    home.sessionPath = [
      "$HOME/.cargo/bin"
    ];
  };
  cfgGo = {
    home.packages = with pkgs; [
      go
      go-migrate
    ];
  };
  cfgDotnet = {
    home.packages = with pkgs; [
      dotnet-sdk_9
    ];
    home.sessionVariables = {
      # See https://stackoverflow.com/q/74895147
      DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
    };
    home.sessionPath = [
      "$HOME/.dotnet/tools"
    ];
  };
  cfgNode = {
    home.packages = with pkgs; [
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

# Common applications that are used in a desktop environment
{
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) isDarwin isLinux;
  inherit (lib) mkIf;
in
{
  config = {
    home.packages = with pkgs.unstable; [
      jetbrains-toolbox
    ];
  }
  // (mkIf isDarwin {
    homebrew.brews = [
      "asdf"
      "claude-code"
    ];
    homebrew.casks = [
      "cursor"
      "db-browser-for-sqlite"
      "insomnia"
    ];
  })
  // (mkIf isLinux {
    home.packages = with pkgs.unstable; [
      sqlitebrowser
      code-cursor
      insomnia
    ];
  });
}

# Common applications that are used in a desktop environment
{
  config,
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
      brotli
      cloc
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
      asdf-vm
      sqlitebrowser
      code-cursor
      insomnia
    ];
  });
}
// (import ../03-apps/git { inherit config lib pkgs; })

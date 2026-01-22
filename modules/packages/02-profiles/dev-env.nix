# Common applications that are used in a desktop environment
{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
in
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs.unstable; [
        asdf-vm
        jetbrains-toolbox
        brotli
        cloc
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "claude-code"
        "cursor"
        "db-browser-for-sqlite"
        "insomnia"
      ];
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        sqlitebrowser
        code-cursor
        insomnia
      ];
    })
  ];
}

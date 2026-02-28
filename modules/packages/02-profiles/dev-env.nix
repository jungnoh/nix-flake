# Common applications that are used in a desktop environment
{
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
        nil
        opencode
        claude-code
      ];
    }
    (onlyDarwin {
      homebrew.casks = [
        "db-browser-for-sqlite"
        "insomnia"
      ];
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        sqlitebrowser
        insomnia
      ];
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs.unstable; [
          openssl_3
        ];
      };
    })
  ];
}

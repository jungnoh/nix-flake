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
        nil
        opencode
        claude-code
      ];
      home.programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "toml"
          "rust"
          "html"
          "dockerfile"
          "sql"
          "make"
          "material-icon-theme"
          "scss"
          "csharp"
          "terraform"
          "opencode"
          "csv"
          "proto"
          "just"
        ];
        userSettings = {
          icon_theme = "Material Icon Theme";
          theme = {
            mode = "dark";
            dark = "Ayu Dark";
            light = "Ayu Light";
          };
          hour_format = "hour24";

          base_keymap = "VSCode";
          vim_mode = true;

          # Tell Zed to use direnv and direnv can use a flake.nix environment
          load_direnv = "shell_hook";
        };
      };
    }
    (onlyDarwin {
      homebrew.casks = [
        "cursor"
        "db-browser-for-sqlite"
        "insomnia"
      ];
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        code-cursor
        sqlitebrowser
        insomnia
      ];
    })
  ];
}

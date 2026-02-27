# Common applications that are used in a desktop environment
{
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
  keysToRemove = {
    "ctrl-b" = [
      "(VimControl && !menu)"
      "vim_mode == literal"
    ];
    "ctrl-f" = [
      "(VimControl && !menu)"
      "vim_mode == literal"
    ];
    "ctrl-s" = [
      "vim_mode == literal"
      "vim_mode == insert"
    ];
    "ctrl-w" = [
      "vim_mode == literal"
      "vim_mode == insert"
      "Picker > Editor"
      "((VimControl && !menu) || (!Editor && !Terminal))"
    ];
    "ctrl-c" = [
      "vim_mode == visual"
      "vim_mode == literal"
      "vim_mode == insert"
      "vim_mode == replace"
      "vim_mode == operator"
      "vim_mode == waiting"
      "GitCommit > ((Editor && VimControl) && vim_mode == normal)"
      "((vim_mode == helix_normal) || vim_mode == helix_select) && !menu"
    ];
    "ctrl-v" = [
      "vim_mode == literal"
      "vim_mode == insert"
      "vim_mode == replace"
      "vim_mode == waiting"
      "(VimControl && !menu)"
    ];
  };

  keysToRemoveGrouped = builtins.groupBy (pair: pair.context) (
    builtins.concatMap (key: map (context: { inherit context key; }) keysToRemove.${key}) (
      builtins.attrNames keysToRemove
    )
  );
  keysToRemoveFinal = map (context: {
    inherit context;
    bindings = builtins.listToAttrs (
      map (p: {
        name = p.key;
        value = null;
      }) keysToRemoveGrouped.${context}
    );
  }) (builtins.attrNames keysToRemoveGrouped);

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
          theme = "Ayu Dark";
          theme_overrides = {
            "Ayu Dark" = {
              "border.focused" = "#16436EFF";
              "elevated_surface.background" = "#0F0F0FFF";
              "surface.background" = "#0F0F0FFF";
              "background" = "#050505FF";
              "status_bar.background" = "#050505FF";
              "title_bar.background" = "#050505FF";
              "toolbar.background" = "#000000FF";
              "tab_bar.background" = "#0F0F0FFF";
              "tab.inactive_background" = "#0F0F0FFF";
              "tab.active_background" = "#000000FF";
              "panel.background" = "#0F0F0FFF";
              "pane.focused_border" = "#16436EFF";
              "editor.background" = "#000000FF";
              "editor.gutter.background" = "#000000FF";
              "editor.subheader.background" = "#0F0F0FFF";
              "editor.highlighted_line.background" = "#0F0F0FFF";
              "editor.line_number" = "#86868AFF";
              "terminal.background" = "#000000FF";
              "deleted.background" = "#541313FF";
              "syntax" = {
                "comment" = {
                  "color" = "#9A9FADFF";
                };
              };
              "panel.overlay_background" = "#0F0F0FFF";
              "panel.overlay_hover" = "#050505FF";
            };
          };

          vim_mode = true;
          base_keymap = "VSCode";

          # Tell Zed to use direnv and direnv can use a flake.nix environment
          load_direnv = "shell_hook";
        };
        userKeymaps = keysToRemoveFinal ++ [
          {
            context = "(VimControl && !menu)";
            bindings = {
              "ctrl-b" = null;
            };
          }
          {
            context = "vim_mode == literal";
            bindings = {
              "ctrl-b" = null;
            };
          }
          {
            bindings = {
              "ctrl-b" = "workspace::ToggleLeftDock";
            };
          }
        ];
      };
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

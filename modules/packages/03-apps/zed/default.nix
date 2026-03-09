# Common applications that are used in a desktop environment
{
  pkgs,
  lib,
  ctx,
  ...
}:
let
  inherit (ctx) onlyLinux;
in
{
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      home.programs.zed-editor = {
        enable = true;
        package = pkgs.zed-editor;
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
          buffer_font_family = "JetBrainsMono Nerd Font";
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
        userKeymaps = [
          # https://zed.dev/docs/vim#restoring-common-text-editing-and-zed-keybindings
          {
            context = "Editor && !menu";
            bindings = {
              "ctrl-f" = "buffer_search::Deploy";
              "ctrl-c" = "editor::Copy";
              "ctrl-x" = "editor::Cut";
              "ctrl-v" = "editor::Paste";
              "ctrl-a" = "editor::SelectAll";
              "ctrl-y" = "editor::Undo";
              "ctrl-t" = "project_symbols::Toggle";
              "ctrl-o" = "workspace::Open";
              "ctrl-s" = "workspace::Save";
              "ctrl-b" = "workspace::ToggleLeftDock";
            };
          }
        ];
      };
    }
    (onlyLinux {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          openssl_3
        ];
      };
    })
  ];
}

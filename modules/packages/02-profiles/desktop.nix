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
  config =
    { }
    // (mkIf isDarwin {
      homebrew.casks = [
        "notion"
        "telegram"
        "spotify"
        "obsidian"
        "1password"
        # macOS Only
        "claude" # Claude Code is installed at dev-env.nix
        "iterm2"
        "fuwari"
        "betterdisplay"
      ];
      homebrew.masApps = {
        "KakaoTalk" = 869223134;
        "한컴오피스 한글 Viewer" = 416746898;
        "Windows App" = 1295203466;
      };
    })
    // (mkIf isLinux {
      home.packages = with pkgs.unstable; [
        telegram-desktop
        spotify
        obsidian
        _1password-gui
      ];
    });
}

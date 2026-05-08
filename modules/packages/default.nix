{
  features,
  ...
}:
let
  commonModules = [
    ./02-profiles/common.nix
    ./02-profiles/containers.nix
    ./03-apps/zsh
    ./03-apps/git.nix
    ./03-apps/tailscale.nix
    ./03-apps/devtools.nix
    ./03-apps/vscode.nix
    ./03-apps/zed.nix
  ];

  featuresModuleMap = {
    desktop = [
      ./02-profiles/desktop.nix
      ./02-profiles/desktop-basic.nix
      ./03-apps/ghostty.nix
    ];
    desktop-basic = [
      ./02-profiles/desktop-basic.nix
      ./03-apps/ghostty.nix
    ];
    personal = [ ./02-profiles/personal.nix ];
    work = [ ./02-profiles/work.nix ];
    kde = [ ./02-profiles/kde.nix ];
    games = [ ./02-profiles/games.nix ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;
in
commonModules ++ featureModules

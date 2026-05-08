{
  features,
  languages,
  ...
}:
let
  commonModules = [
    ./02-profiles/common.nix
    ./03-apps/git
    ./03-apps/zsh
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
    dev-env = [
      ./02-profiles/containers.nix
      ./02-profiles/dev-env.nix
      ./02-profiles/dev-env-cloud.nix
      ./02-profiles/dev-env-database.nix
      ./03-apps/zed
    ];
    containers = [ ./02-profiles/containers.nix ];
    personal = [ ./02-profiles/personal.nix ];
    work = [ ./02-profiles/work.nix ];
    kde = [ ./02-profiles/kde.nix ];
    games = [ ./02-profiles/games.nix ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;

  languageModules = [
    (import ./03-apps/languages { inherit languages; })
  ];
in
commonModules ++ featureModules ++ languageModules

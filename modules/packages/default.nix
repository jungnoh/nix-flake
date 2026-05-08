{
  features,
  ...
}:
let
  featuresModuleMap = {
    kde = [ ./app-sets/kde.nix ];
    games = [ ./app-sets/games.nix ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;
in
(import ./apps) ++ (import ./app-sets) ++ featureModules

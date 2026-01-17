{
  features,
  languages,
  ctx,
}:
let
  inherit (ctx) isDarwin isLinux;

  listNixFiles =
    path:
    builtins.map (file: "${path}/${file}") (
      builtins.filter (file: builtins.match ".*\\.nix$" file != null) (
        builtins.attrNames (builtins.readDir path)
      )
    );

  commonModules =
    (if isDarwin then (listNixFiles ./01-system/darwin) else (listNixFiles ./01-system/linux))
    ++ [ ./03-apps/zsh ];

  featuresModuleMap = {
    desktop = [
      ./02-profiles/desktop.nix
      ./02-profiles/desktop-basic.nix
    ];
    dev-env = [
      ./02-profiles/containers.nix
      ./02-profiles/dev-env.nix
      ./02-profiles/dev-env-cloud.nix
      ./02-profiles/dev-env-database.nix
    ];
    containers = [ ./02-profiles/containers.nix ];
    personal = [ ./02-profiles/personal.nix ];
    work = [ ./02-profiles/work.nix ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;

  languageModules = [
    (import ./03-apps/languages { inherit languages; })
  ];
in
commonModules ++ featureModules ++ languageModules

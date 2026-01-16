{ features, ctx }:
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
    ++ (listNixFiles ./02-app-common);

  featuresModuleMap = {
    desktop = [
      ./02-profiles/desktop.nix
      ./02-profiles/desktop-basic.nix
    ];
    dev-env = [
      ./02-profiles/dev-env.nix
      ./02-profiles/dev-env-cloud.nix
    ];
    personal = [ ./02-profiles/personal.nix ];
    work = [ ./02-profiles/work.nix ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;
in
commonModules ++ featureModules

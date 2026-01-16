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
    (
      if isDarwin then
        (listNixFiles ./01-system/darwin) ++ (listNixFiles ./02-app-darwin)
      else
        (listNixFiles ./01-system/linux)
    )
    ++ (listNixFiles ./02-app-common);

  featuresModuleMap = {
    personal = [ ./02-app-envs/personal.nix ];
    work = [ ./02-app-envs/work.nix ];
    desktop = [
      ./02-app-envs/desktop.nix
      ./02-app-envs/desktop-basic.nix
    ];
    dev-env = [
      ./02-app-envs/dev-env.nix
      ./02-app-envs/dev-env-cloud.nix
    ];
  };

  featureModules = builtins.concatMap (p: featuresModuleMap."${p}") features;
in
commonModules ++ featureModules

{ profiles }:
let
  listNixFiles =
    path:
    builtins.map (file: "${path}/${file}") (
      builtins.filter (file: builtins.match ".*\\.nix$" file != null) (
        builtins.attrNames (builtins.readDir path)
      )
    );

  commonModules = (listNixFiles ../01-system-linux) ++ (listNixFiles ../02-app-common);
  personalModules =
    if (builtins.elem "personal" profiles) then [ ../02-app-envs/personal.nix ] else [ ];
  workModules = if (builtins.elem "work" profiles) then [ ../02-app-envs/work.nix ] else [ ];
in
commonModules ++ personalModules ++ workModules

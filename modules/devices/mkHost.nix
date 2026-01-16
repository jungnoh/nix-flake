{
  inputs,
  system,
  features,
  system_modules ? [ ],
  username ? "jungnoh",
}:
let
  inherit (inputs) home-manager nixpkgs-unstable;

  isDarwin = builtins.elem system [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  isLinux = builtins.elem system [
    "aarch64-linux"
    "x86_64-linux"
  ];

  homeManagerKey = if isDarwin then "darwinModules" else "nixosModules";
  homeManager = home-manager.${homeManagerKey}.home-manager;

  mkPackages =
    if isDarwin then
      (import ../packages/00-root/darwin.nix)
    else
      (import ../packages/00-root/linux.nix);

  modules =
    ((import ../base) { inherit nixpkgs-unstable; })
    ++ system_modules
    ++ [ homeManager ]
    ++ (mkPackages { profiles = features; });

  # Context for me to use, will be passed via specialArgs
  ctx = {
    inherit isDarwin isLinux username;
  };

in
{
  inherit system modules;
  specialArgs = {
    inherit
      inputs
      system
      ctx
      ;
  };
}

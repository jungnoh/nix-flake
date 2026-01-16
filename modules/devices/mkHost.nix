{
  inputs,
  system,
  hostname,
  features,
  languages ? [ ],
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

  # Context for me to use, will be passed via specialArgs
  ctx = {
    inherit
      isDarwin
      isLinux
      username
      hostname
      ;
  };

  homeManagerKey = if isDarwin then "darwinModules" else "nixosModules";
  homeManager = home-manager.${homeManagerKey}.home-manager;

  modules =
    ((import ../base) { inherit nixpkgs-unstable; })
    ++ system_modules
    ++ [ homeManager ]
    ++ (import ../packages { inherit features ctx languages; });
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

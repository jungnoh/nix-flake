{
  inputs,
  system,
  hostname,
  features,
  languages ? [ ],
  disko_modules ? [ ],
  system_modules ? [ ],
  username ? "jungnoh",
}:
let
  inherit (inputs) home-manager nixpkgs-unstable disko;

  isDarwin = builtins.elem system [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  isLinux = builtins.elem system [
    "aarch64-linux"
    "x86_64-linux"
  ];

  onlyDarwin = { ... }@inputs: (if isDarwin then inputs else { });
  onlyLinux = { ... }@inputs: (if isLinux then inputs else { });

  # Context for me to use, will be passed via specialArgs
  ctx = {
    inherit
      isDarwin
      isLinux
      onlyDarwin
      onlyLinux
      username
      hostname
      ;
  };

  homeManagerKey = if isDarwin then "darwinModules" else "nixosModules";
  homeManager = home-manager.${homeManagerKey}.home-manager;

  diskoModules =
    if builtins.length disko_modules > 0 then
      [
        disko.nixosModules.disko
      ]
      ++ disko_modules
    else
      [ ];

  modules =
    ((import ../base) { inherit nixpkgs-unstable; })
    ++ [ homeManager ]
    ++ system_modules
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

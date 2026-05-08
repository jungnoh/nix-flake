{
  inputs,
  system,
  hostname,
  features,
  disko_modules ? [ ],
  system_modules ? [ ],
  username ? "jungnoh",
  use_agenix ? false,
}:
let
  inherit (inputs)
    home-manager
    disko
    agenix
    ;

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

  mkIfDarwin = condition: { ... }@cfg: (if isDarwin then (lib.mkIf condition cfg) else { });
  mkIfLinux = condition: { ... }@cfg: (if isLinux then (lib.mkIf condition cfg) else { });

  lib = inputs.nixpkgs.lib.extend (
    self: super: {
      inherit
        isDarwin
        isLinux
        onlyDarwin
        onlyLinux
        mkIfDarwin
        mkIfLinux
        ;
    }
  );

  # Context for me to use, will be passed via specialArgs
  ctx = {
    inherit username hostname;
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

  agenixModules =
    if use_agenix then
      [
        agenix.nixosModules.default
        {
          environment.systemPackages = [ agenix.packages.${system}.default ];
        }
      ]
    else
      [ ];

  modules =
    (import ../base)
    ++ diskoModules
    ++ agenixModules
    ++ [ homeManager ]
    ++ system_modules
    ++ (import ../packages { inherit features ctx; });

  systemArgs = {
    inherit system modules;
    specialArgs = {
      inherit
        lib
        inputs
        system
        ctx
        ;
    };
  };
in
if isDarwin then
  {
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem systemArgs;
  }
else
  {
    nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem systemArgs;
  }

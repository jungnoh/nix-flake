{
  inputs,
  system,
  hostname,
  modules ? [ ],
  myOptions ? { },
  username ? "jungnoh",
}:
let
  inherit (inputs) home-manager disko agenix;

  darwinModules = [
    home-manager.darwinModules.home-manager
    {
      inherit myOptions;
    }
  ]
  ++ (import ../modules)
  ++ modules;

  linuxModules = [
    home-manager.nixosModules.home-manager
    disko.nixosModules.disko
    agenix.nixosModules.default
    {
      environment.systemPackages = [ agenix.packages.${system}.default ];
      inherit myOptions;
    }
  ]
  ++ (import ../modules)
  ++ modules;

  isDarwin = builtins.elem system [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  isLinux = builtins.elem system [
    "aarch64-linux"
    "x86_64-linux"
  ];
  extendedLib = inputs.nixpkgs.lib.extend (
    self: super: {
      inherit isDarwin isLinux;

      onlyDarwin = { ... }@inputs: (if isDarwin then inputs else { });
      onlyLinux = { ... }@inputs: (if isLinux then inputs else { });

      mkIfDarwin = condition: { ... }@cfg: (if isDarwin then (self.mkIf condition cfg) else { });
      mkIfLinux = condition: { ... }@cfg: (if isLinux then (self.mkIf condition cfg) else { });

      byPlatform =
        {
          common ? { },
          linux ? { },
          darwin ? { },
        }:
        self.mkMerge [
          common
          (if isDarwin then darwin else linux)
        ];
    }
  );

  systemArgs = {
    inherit system;
    specialArgs = {
      inherit system inputs;
      lib = extendedLib;
      ctx = {
        inherit username hostname;
      };
    };
  };
in
if isDarwin then
  {
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem (
      systemArgs
      // {
        modules = darwinModules ++ modules;
      }
    );
  }
else
  {
    nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem (
      systemArgs
      // {
        modules = linuxModules ++ modules;
      }
    );
  }

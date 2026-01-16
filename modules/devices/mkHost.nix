{ inputs, system, system_modules, features }:
let
  isDarwin = builtins.elem system ["aarch64-darwin" "x86_64-darwin"];
  isLinux = builtins.elem system ["aarch64-linux" "x86_64-linux"];

  inherit (inputs) home-manager nixpkgs-unstable;

  modules = 
    ((import ../base) { inherit nixpkgs-unstable; })
    ++ system_modules
    ++ [
      (if isDarwin
        then home-manager.darwinModules.home-manager 
        else home-manager.nixosModules.home-manager
      )
    ] ++
    (import ../packages/00-root/linux.nix { profiles = features; });

in {
  inherit system modules;
  specialArgs = {
    inherit inputs system isDarwin isLinux;
  };
}
{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };
  outputs = inputs@{ self, home-manager, nixpkgs-darwin, nixpkgs-linux, nixpkgs-unstable, nix-darwin, ... }:
    let
      mkDarwinHost = import ./lib/mkDarwinHost.nix {
        inputs = {
          home-manager = home-manager;
          nix-darwin = nix-darwin;
          nixpkgs = nixpkgs-darwin;
          nixpkgs-unstable = nixpkgs-unstable;
        };
      };
      mkLinuxHost = import ./lib/mkLinuxHost.nix {
        inputs = {
          home-manager = home-manager;
          nixpkgs = nixpkgs-linux;
          nixpkgs-unstable = nixpkgs-unstable;
        };
      };

      linuxConfigurations = {
        # Example Linux host - uncomment and customize when needed
        # "jungnoh@linux-dev" = mkLinuxHost {
        #   hostname = "linux-dev";
        #   username = "jungnoh";
        #   system = "x86_64-linux";
        #   includePersonal = true;
        # };
      };
    in
    {
      darwinConfigurations = builtins.mapAttrs
        (name: value: mkDarwinHost {
          hostname = name;
          profiles = value.profiles;
        })
        {
          # Macbook Pro
          "suisei" = {
            hostname = "suisei";
            profiles = [ "common" "work" ];
          };
          # Home Mac Mini
          "koyori" = {
            hostname = "koyori";
            profiles = [ "common" "personal" ];
          };
          # Personal Macbook Pro
          "shigureui" = {
            hostname = "shigureui";
            profiles = [ "common" "personal" ];
          };
        };
      homeConfigurations = linuxConfigurations;

      formatter.aarch64-darwin = nixpkgs-unstable.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      formatter.x86_64-linux = nixpkgs-unstable.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}

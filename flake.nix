{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixpkgs-25.11-linux";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  outputs = inputs@{ self, home-manager, nixpkgs-darwin, nixpkgs-linux, nixpkgs-unstable, nix-darwin, ... }:
    let
      configuration = { pkgs, lib, config, ... }: {
        nixpkgs.config.allowUnfree = true;
        ## Configs needed for nix-darwin

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment = {
          systemPackages = [ pkgs.vim ];
          systemPath = [
            "/opt/homebrew/bin"
            "~/go/bin"
          ];
          pathsToLink = [ "/Applications" ];
        };
        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        security.pam.enableSudoTouchIdAuth = true;
        system.defaults = {
          finder = {
            _FXShowPosixPathInTitle = true; # show full path in finder title
            AppleShowAllExtensions = true; # show all file extensions
            FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
            QuitMenuItem = true; # enable quit menu item
            ShowPathbar = true; # show path bar
            ShowStatusBar = true; # show status bar
          };
          dock = {
            autohide = true;
            show-recents = false; # disable recent apps
          };
        };
      };

      nix.settings = {
        "allowed-users" = [ "root" "jungnoh" ];
      };

      overlays = import ./overlays.nix;
      overlay_module = { config, pkgs, lib, ... }: {
        nixpkgs.overlays = overlays {
          inherit config pkgs nixpkgs-unstable lib;
        };
      };
    in
    {
      # Hostname
      darwinConfigurations = {
        "imac-junghoonnoh" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            configuration
            overlay_module
          ] ++ import ./modules/common.nix;
        };
        # Macbook Pro
        "suisei" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            configuration
            overlay_module
          ] ++ import ./modules/common.nix ++ import ./modules/personal.nix;
        };
        # Home Mac Mini
        "koyori" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            configuration
            overlay_module
          ] ++ import ./modules/common.nix ++ import ./modules/personal.nix;
        };
	# Personal Macbook Pro
	"shigureui" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            configuration
            overlay_module
          ] ++ import ./modules/common.nix ++ import ./modules/personal.nix;
        };
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };
}

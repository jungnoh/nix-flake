{ inputs }:
{ hostname
, system ? "aarch64-darwin"
, username ? "jungnoh"
, extraModules ? [ ]
, profiles ? [ "common" "personal" ]
}:
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
    # Set Git commit hash for darwin-version.
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
    system.primaryUser = username;

    security.pam.services.sudo_local.touchIdAuth = true;
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

  overlay_module = { config, pkgs, lib, ... }: {
    nixpkgs.overlays = import ./overlays.nix {
      inherit config pkgs lib system;
      nixpkgs-unstable = inputs.nixpkgs-unstable;
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs username; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    configuration
    overlay_module
    (import ./home.nix)
    (import ./envs.nix)
  ]
  ++ import ../modules/00-root/darwin.nix { inherit profiles; };
}

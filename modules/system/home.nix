{ pkgs, lib, config, options, ... }:
let
  user = "jungnoh";
in with lib; {
  options = with types; {
    home = {
      file = mkOption {
        type = attrs;
        default = {};
        description = "Files to place directly in $HOME";
      };

      configFile = mkOption {
        type = attrs;
        default = {};
        description = "Config files to place in $HOME/.config";
      };

      services = mkOption {
        type = attrs;
        default = {};
        description = "Home-manager provided user services";
      };

      packages = mkOption {
        type = listOf package;
        default = [];
        description = "Home-manager provided packages";
      };

      programs = mkOption {
        type = attrs;
        default = {};
        description = "Home-manager provided programs";
      };
    };
  };
  
  config = {
    programs.zsh.enable = true;
    users.users.${user} = {
      name = user;
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };

    # Initialize Home
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };

      users.${user} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          packages = mkAliasDefinitions options.home.packages;
          stateVersion = "23.11";
        };
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
        };
      };
    };

    system.activationScripts.applications.text = pkgs.lib.mkForce (''
      echo "setting up ~/Applications/Nix..."
      rm -rf /Users/jungnoh/Applications/Nix
      mkdir -p /Users/jungnoh/Applications/Nix
      chown jungnoh /Users/jungnoh/Applications/Nix
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
        src=$(/usr/bin/stat -f%Y "$f")
        appname=$(basename "$src")
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/jungnoh/Applications/Nix/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
      done
    '');
  };
}

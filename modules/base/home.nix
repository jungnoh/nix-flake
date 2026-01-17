{
  pkgs,
  lib,
  config,
  options,
  ctx,
  ...
}:
let
  inherit (ctx) username isDarwin;

  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
with lib;
{
  options = with types; {
    home = {
      file = mkOption {
        type = attrs;
        default = { };
        description = "Files to place directly in $HOME";
      };

      configFile = mkOption {
        type = attrs;
        default = { };
        description = "Config files to place in $HOME/.config";
      };

      services = mkOption {
        type = attrs;
        default = { };
        description = "Home-manager provided user services";
      };

      shellAliases = mkOption {
        type = attrs;
        default = { };
        description = "Shell aliases";
      };

      sessionPath = mkOption {
        type = listOf str;
        default = [ ];
        description = "Session paths";
      };

      sessionVariables = mkOption {
        type = attrs;
        default = { };
        description = "Session variables";
      };

      packages = mkOption {
        type = listOf package;
        default = [ ];
        description = "Home-manager provided packages";
      };

      programs = mkOption {
        type = attrs;
        default = { };
        description = "Home-manager provided programs";
      };
    };
  };

  config = {
    users.users.${username} = {
      name = username;
      home = homeDir;
    };

    # Initialize Home
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };

      users.${username} = {
        home = {
          homeDirectory = homeDir;
          file = mkAliasDefinitions options.home.file;
          packages = mkAliasDefinitions options.home.packages;
          shellAliases = mkAliasDefinitions options.home.shellAliases;
          sessionPath = mkAliasDefinitions options.home.sessionPath;
          sessionVariables = mkAliasDefinitions options.home.sessionVariables;
          stateVersion = "25.11";
        };
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
        };
      };
    };
  };
}

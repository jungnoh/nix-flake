{
  pkgs,
  lib,
  config,
  options,
  ...
}:
let
  username = "jungnoh";
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
    programs.zsh.enable = true;
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
      shell = pkgs.zsh;
    };

    # Initialize Home
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };

      users.${username} = {
        home = {
          homeDirectory = "/Users/${username}";
          file = mkAliasDefinitions options.home.file;
          packages = mkAliasDefinitions options.home.packages;
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

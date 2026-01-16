{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) isDarwin isLinux;
  inherit (lib) mkIf;
in
{
  # TODO: Wireguard
  config = {
    home.packages = with pkgs.unstable; [
      vault
    ];
    home.shellAliases = {
      awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
      vaultlogin = "vault login -method=oidc";
    };
  }
  // mkIf isDarwin {
    homebrew.casks = [
      "slack"
      "figma"
    ];
  }
  // mkIf isLinux {
    home.packages = with pkgs.unstable; [
      slack
    ];
  };
}

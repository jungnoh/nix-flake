{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
in
{
  # TODO: Wireguard
  config = lib.mkMerge [
    {
      home.packages = with pkgs.unstable; [
        vault
      ];
      home.shellAliases = {
        awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
        vaultlogin = "vault login -method=oidc";
      };
    }
    (onlyDarwin {
      homebrew.casks = [
        "slack"
        "figma"
      ];
    })
    (onlyLinux {
      home.packages = with pkgs.unstable; [
        slack
      ];
    })
  ];
}

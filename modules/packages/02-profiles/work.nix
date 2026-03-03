{
  lib,
  pkgs,
  ...
}:
{
  # TODO: Wireguard
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        vault
        slack
      ];
      home.shellAliases = {
        awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
        vaultlogin = "vault login -method=oidc";
      };
    }
  ];
}

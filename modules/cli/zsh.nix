{ config, lib, pkgs, ... }:
{
  home.programs.zsh = {
    shellAliases = {
            awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
        };
    };
}

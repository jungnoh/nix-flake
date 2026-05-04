{ serviceDefs, mkBackup }:
{ pkgs, config, ... }:
let
  inherit (serviceDefs.external) forgejo;
in
{
  # Forejo: https://wiki.nixos.org/wiki/Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DISABLE_SSH = true;
        ROOT_URL = "https://git.suisei.dev";
        HTTP_PORT = forgejo.port;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      mailer.ENABLED = false;
    };
  };
}
// mkBackup {
  inherit pkgs config;
  name = "forgejo";
  user = "forgejo";
  healthCheckKey = "K0ENg1XT92xHS5VTVKHc1l7KXbP8f0VS";
  script = ''
    cd $TDIR
    ${pkgs.forgejo-lts}/bin/forgejo dump -c /var/lib/forgejo/custom/conf/app.ini -f forgejo-dump.zip
  '';
}

{ serviceDefs, mkBackup }:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (serviceDefs.external) linkwarden;
in
lib.mkMerge [
  {
    age.secrets.linkwarden-nextauth = {
      file = ../../../secrets/soyo-linkwarden-nextauth.age;
      owner = linkwarden.user;
    };
    age.secrets.linkwarden-postgres = {
      file = ../../../secrets/soyo-linkwarden-postgres.age;
      owner = linkwarden.user;
    };
    age.secrets.linkwarden-gemini = {
      file = ../../../secrets/gemini.age;
      owner = linkwarden.user;
    };
    services.linkwarden = {
      enable = true;
      enableRegistration = false;
      port = linkwarden.port;
      secretFiles = {
        POSTGRES_PASSWORD = config.age.secrets.linkwarden-postgres.path;
        NEXTAUTH_SECRET = config.age.secrets.linkwarden-nextauth.path;
        OPENAI_API_KEY = config.age.secrets.linkwarden-gemini.path;
      };
      environment = {
        CUSTOM_OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
        OPENAI_MODEL = "gemini-3.5-flash";
        NEXTAUTH_URL = "https://${linkwarden.hostname}/api/v1/auth";
      };
    };
  }
  (mkBackup { inherit pkgs config; } {
    name = "linkwarden";
    user = "linkwarden";
    time = "*-*-* 3:00:00";
    healthCheckKey = "gwAioyFKlIIqzBkt3oEWt7qDS2u60zXF";
    script = ''
      mkdir -p $TDIR/db
      ${pkgs.postgresql_17}/bin/pg_dump -h /run/postgresql -U linkwarden -d linkwarden --inserts > $TDIR/db/postgres.sql
      mkdir -p $TDIR/data
      cp -r /var/lib/linkwarden $TDIR/data
    '';
  })
]

{ pkgs, config, ... }:
let
  externalPorts = {
    linkwarden = 8001;
  };
  internalPorts = {
    linkwarden = 9001;
  };

  pgdumpall = "${pkgs.postgresql_17}/bin/pg_dumpall";
  s5cmd = "${pkgs.s5cmd}/bin/s5cmd";
in
{
  # Tailscale
  # See https://wiki.nixos.org/wiki/Tailscale
  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Github Actions Runner
  age.secrets.ga-pekora-token.file = ../../../secrets/soyo-github-runner-pekora.age;
  services.github-runners = {
    pekora = {
      enable = true;
      name = "pekora-cs";
      tokenFile = config.age.secrets.ga-pekora-token.path;
      url = "https://github.com/jungnoh/pekora-cs";
    };
  };

  # Nginx
  networking.firewall.allowedTCPPorts = builtins.attrValues externalPorts;
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."linkwarden" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = externalPorts.linkwarden;
        }
      ];
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString internalPorts.linkwarden}";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
  };

  # Linkwarden
  age.secrets.linkwarden-nextauth = {
    file = ../../../secrets/soyo-linkwarden-nextauth.age;
    owner = "linkwarden";
  };
  age.secrets.linkwarden-postgres = {
    file = ../../../secrets/soyo-linkwarden-postgres.age;
    owner = "linkwarden";
  };
  age.secrets.linkwarden-gemini = {
    file = ../../../secrets/gemini.age;
    owner = "linkwarden";
  };
  services.linkwarden = {
    enable = true;
    enableRegistration = false;
    port = internalPorts.linkwarden;
    secretFiles = {
      POSTGRES_PASSWORD = config.age.secrets.linkwarden-postgres.path;
      NEXTAUTH_SECRET = config.age.secrets.linkwarden-nextauth.path;
      OPENAI_API_KEY = config.age.secrets.linkwarden-gemini.path;
    };
    environment = {
      CUSTOM_OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
      OPENAI_MODEL = "gemini-3.1-flash-lite-preview";
      # This is wrong, but works anyway
      NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
    };
  };

  # Linkwarden backup
  age.secrets.backblaze-key = {
    file = ../../../secrets/soyo-backblaze.age;
    owner = "linkwarden";
  };
  systemd.timers."linkwarden-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 3:00:00";
      Persistent = true;
      Unit = "linkwarden-backup.service";
    };
  };
  systemd.services."linkwarden-backup" = {
    script = ''
      export TDIR=$(${pkgs.mktemp}/bin/mktemp -d)
      export POSTGRES_PASSWORD=$(< ${config.age.secrets.linkwarden-postgres.path})

      export AWS_ACCESS_KEY_ID=00544cfc0850c450000000003
      export AWS_SECRET_ACCESS_KEY=$(< ${config.age.secrets.backblaze-key.path})
      export S3_ENDPOINT_URL=https://s3.us-east-005.backblazeb2.com

      echo "Dumping database"
      ${pgdumpall} -d 'postgresql://linkwarden@localhost/linkwarden?host=/run/postgresql' --no-role-passwords --inserts > $TDIR/postgres.sql
      echo "Uploading database dump"
      ${s5cmd} sync $TDIR/ s3://jungnoh-soyo/linkwarden/db/
      echo "Uploading data"
      ${s5cmd} sync /var/lib/linkwarden s3://jungnoh-soyo/linkwarden/data/
      echo "Cleaning up"
      rm -rf $TDIR
      echo "All done!"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "linkwarden";
    };
  };
}

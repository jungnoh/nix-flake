{ pkgs, config, ... }:
let
  inherit (pkgs) lib;

  externalPorts = {
    linkwarden = 8001;
    forgejo = 8002;
  };
  internalPorts = {
    linkwarden = 9001;
    forgejo = 9002;
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
        proxyPass = "http://localhost:${toString internalPorts.linkwarden}";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
    virtualHosts.forgejo = {
      listen = [
        {
          addr = "0.0.0.0";
          port = externalPorts.forgejo;
        }
      ];
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/" = {
        proxyPass = "http://localhost:${toString internalPorts.forgejo}";
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
  age.secrets.linkwarden-backblaze-key = {
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
      export AWS_SECRET_ACCESS_KEY=$(< ${config.age.secrets.linkwarden-backblaze-key.path})
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

  # Forejo: https://wiki.nixos.org/wiki/Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        SSH_PORT = lib.head config.services.openssh.ports;
        HTTP_PORT = internalPorts.forgejo;
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

  # Action runner for Forgejo
  age.secrets.forgejo-runner = {
    file = ../../../secrets/soyo-forgejo-runner.age;
    owner = "forgejo";
  };
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "soyo";
      url = "http://localhost:${toString internalPorts.forgejo}";
      tokenFile = config.age.secrets.forgejo-runner.path;
      labels = [
        "native:host"
      ];
    };
  };

  # Forgejo backup
  age.secrets.forgejo-backblaze-key = {
    file = ../../../secrets/soyo-backblaze.age;
    owner = "forgejo";
  };
  systemd.timers."forgejo-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 2:00:00";
      Persistent = true;
      Unit = "forgejo-backup.service";
    };
  };
  systemd.services."forgejo-backup" = {
    script = ''
      export TDIR=$(${pkgs.mktemp}/bin/mktemp -d)

      export AWS_ACCESS_KEY_ID=00544cfc0850c450000000003
      export AWS_SECRET_ACCESS_KEY=$(< ${config.age.secrets.forgejo-backblaze-key.path})
      export S3_ENDPOINT_URL=https://s3.us-east-005.backblazeb2.com

      echo "Dumping"
      cd $TDIR
      ${pkgs.forgejo-lts}/bin/forgejo dump -c /var/lib/forgejo/custom/conf/app.ini -f forgejo-dump.zip
      echo "Uploading"
      ${s5cmd} sync $TDIR/ s3://jungnoh-soyo/forgejo/
      echo "Cleaning up"
      cd ~
      rm -rf $TDIR
      echo "All done!"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "forgejo";
    };
  };
}

let
  serviceDefs = {
    internal = {
      nginx.port = 3939;
      uptimeKuma.port = 39390;
    };
    external = {
      linkwarden = {
        user = "linkwarden";
        hostname = "links.suisei.dev";
        port = 9001;
        nginxConfig = { };
      };
      forgejo = {
        user = "forgejo";
        hostname = "git.suisei.dev";
        port = 9002;
        nginxConfig.extraConfig = "client_max_body_size 512M;";
      };
    };
  };

  mkBackup =
    { pkgs, config }:
    {
      name,
      user,
      healthCheckKey,
      script,
      time ? "*-*-* 2:00:00",
    }:
    let
      healthCheckHost = "http://localhost:${serviceDefs.internal.uptimeKuma.port}";
    in
    {
      age.secrets."backup-storage-key-${name}" = {
        file = ../../../secrets/soyo-backblaze.age;
        owner = user;
      };
      systemd.timers."backup-${name}" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = time;
          Persistent = true;
          Unit = "backup-${name}.service";
        };
      };
      systemd.services."backup-${name}" = {
        script = ''
          export TDIR=$(${pkgs.mktemp}/bin/mktemp -d)
          export AWS_ACCESS_KEY_ID=00544cfc0850c450000000003
          export AWS_SECRET_ACCESS_KEY=$(< ${config.age.secrets."backup-storage-key-${name}".path})
          export S3_ENDPOINT_URL=https://s3.us-east-005.backblazeb2.com

          echo "Dumping"
          ${script}
          echo "Uploading"
          ${pkgs.s5cmd}/bin/s5cmd $TDIR/ s3://jungnoh-soyo/${name}/
          echo "Cleaning up"
          cd /
          rm -rf $TDIR

          echo "Reporting to Uptime Kuma"
          ${pkgs.curl}/bin/curl "${healthCheckHost}/api/push/${healthCheckKey}?status=up&msg=OK&ping="
          echo "All done!"
        '';
        serviceConfig = {
          Type = "oneshot";
          User = user;
        };
      };
    };
in
map (m: m { inherit serviceDefs mkBackup; }) [
  ./ci.nix
  ./forgejo.nix
  ./ingress.nix
  ./linkwarden.nix
  ./tailscale.nix
  ./uptime-kuma.nix
]

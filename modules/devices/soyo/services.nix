{ pkgs, config, ... }:
let
  externalPorts = {
    linkwarden = 8001;
  };
  internalPorts = {
    linkwarden = 9001;
  };
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
  services.linkwarden = {
    enable = true;
    enableRegistration = false;
    port = internalPorts.linkwarden;
    secretFiles = {
      POSTGRES_PASSWORD = config.age.secrets.linkwarden-postgres.path;
      NEXTAUTH_SECRET = config.age.secrets.linkwarden-nextauth.path;
    };
    environment = {
      # This is wrong, but works anyway
      NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
    };
  };
}

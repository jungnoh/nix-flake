{ serviceDefs, ... }:
{ pkgs, config, ... }:
let
  inherit (pkgs) lib;
  nginxPort = serviceDefs.internal.nginx.port;
in
{
  # Cloudflare Tunnel
  age.secrets.cloudflare-tunnel-token.file = ../../../secrets/cloudflare-tunnel-token.age;
  age.secrets.cloudflare-tunnel-creds.file = ../../../secrets/cloudflare-tunnel-creds.age;
  services.cloudflared = {
    enable = true;
    tunnels."bbd48770-65cd-4b5f-81b3-e8a9333597db" = {
      credentialsFile = config.age.secrets.cloudflare-tunnel-creds.path;
      certificateFile = config.age.secrets.cloudflare-tunnel-token.path;
      default = "http_status:404";
      ingress = lib.mapAttrs' (_: val: {
        name = val.hostname;
        value = "http://localhost:${toString nginxPort}";
      }) serviceDefs.external;
    };
  };

  # Nginx
  networking.firewall.allowedTCPPorts = [ nginxPort ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    commonHttpConfig = ''
      set_real_ip_from 127.0.0.1;
      real_ip_header CF-Connecting-IP;
    '';

    virtualHosts = lib.mapAttrs' (key: val: {
      name = val.hostname;
      value = lib.recursiveUpdate {
        listen = [
          {
            addr = "0.0.0.0";
            port = nginxPort;
          }
        ];
        locations."/robots.txt" = {
          priority = 1;
          return = ''
            200 "User-agent: *\nDisallow: /"
          '';
        };
        locations."/" = {
          proxyPass = "http://localhost:${toString val.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_pass_header Authorization;
            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
          '';
        };
      } val.nginxConfig;
    }) serviceDefs.external;
  };
}

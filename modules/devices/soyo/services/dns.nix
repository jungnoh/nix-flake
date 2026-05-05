{ ... }:
{ config, ... }:
{
  age.secrets."private-dns-records" = {
    file = ../../../../secrets/private-dns-records.age;
    owner = "unbound";
    group = "unbound";
    mode = "0440";
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
  services.unbound = {
    enable = true;
    settings.server = {
      interface = [ "0.0.0.0" ];
      access-control = [
        "100.64.0.0/10 allow" # Tailscale subnet
        "192.168.0.0/24 allow"
        "192.168.39.0/24 allow"
      ];
      include = config.age.secrets.private-dns-records.path;
    };

    settings.forward-zone = [
      {
        name = ".";
        forward-tls-upstream = true;
        forward-addr = [
          "1.1.1.1@853#cloudflare-dns.com"
          "9.9.9.9@853#dns.quad9.net"
        ];
      }
    ];
  };
}

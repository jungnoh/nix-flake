{ serviceDefs, mkBackup }:
{ pkgs, config, ... }:
let
  inherit (pkgs) lib;
  inherit (serviceDefs.internal.uptimeKuma) port;
  username = "uptime-kuma";
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = toString port;
    };
  };
  users.groups.uptime-kuma = { };
  users.users.uptime-kuma = {
    isSystemUser = true;
    group = username;
  };
  systemd.services.uptime-kuma.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = username;
  };
}
// mkBackup {
  inherit pkgs config;
  name = "uptime-kuma";
  user = username;
  healthCheckKey = "zgJoTMK5QHK8Ho3YC4GdWo5pvqOR2PVz";
  script = ''
    ${pkgs.sqlite}/bin/sqlite3 /var/lib/uptime-kuma/kuma.db ".dump" > $TDIR/kuma.sql
  '';
}

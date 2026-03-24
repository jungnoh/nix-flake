{ config, ... }:
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

  systemd.services.tailscale-systray = {
    enable = true;
    description = "Tailscale System Tray";
    after = [ "graphical.target" ];
    wantedBy = [ "default.target" ];

    # Configure the service itself
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/tailscale systray";
    };
  };
}

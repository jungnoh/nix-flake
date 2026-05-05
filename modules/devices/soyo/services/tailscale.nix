{ ... }:
{ config, pkgs, ... }:
{
  # Tailscale
  # See https://wiki.nixos.org/wiki/Tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
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

  # Enlarged UDP socket buffers for the WireGuard userspace socket.
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  # UDP GRO forwarding optimization for subnet router / exit node throughput.
  # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
  systemd.services.tailscale-ethtool-tweaks = {
    description = "Apply ethtool UDP GRO tweaks for Tailscale subnet routing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [
      pkgs.ethtool
      pkgs.iproute2
    ];
    script = ''
      NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
      ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
    '';
  };
}

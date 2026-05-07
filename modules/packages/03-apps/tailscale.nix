{
  useRouting ? false,
  useSSH ? false,
  systray ? false,
}:
{
  config,
  ctx,
  pkgs,
  lib,
  ...
}:
let
  inherit (ctx) onlyLinux onlyDarwin isLinux;
in
lib.mkMerge [
  (onlyLinux {
    services.tailscale = {
      enable = true;
      extraUpFlags = if useSSH then [ "--ssh" ] else [ ];
    };
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    systemd.user.services.tailscale-systray =
      if systray then
        {
          enable = true;
          description = "Tailscale System Tray";
          after = [ "graphical.target" ];
          wantedBy = [ "default.target" ];

          # Configure the service itself
          serviceConfig = {
            Type = "simple";
            ExecStart = "/run/current-system/sw/bin/tailscale systray";
          };
        }
      else
        { enable = false; };
  })
  (
    if (isLinux && useRouting) then
      {
        services.tailscale.useRoutingFeatures = "server";

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
    else
      { }
  )
  (onlyDarwin {
    homebrew.casks = [ "tailscale-app" ];
    home.programs.zsh.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  })
]

{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIfLinux
    onlyLinux
    onlyDarwin
    mkMerge
    ;
in
{
  options.myOptions.tailscale = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    ssh = mkOption {
      type = types.bool;
      default = false;
      description = "Allow use of Tailscale SSH.";
    };
    routing = mkOption {
      type = types.bool;
      default = false;
      description = "Use routing. Only effective in Linux";
    };
    systray = mkOption {
      type = types.bool;
      default = true;
      description = "Create systray service. Only effective in Linux desktop environments.";
    };
  };

  config =
    let
      tsOptions = config.myOptions.tailscale;
    in
    lib.mkIf tsOptions.enable (mkMerge [
      (onlyDarwin {
        homebrew.casks = [ "tailscale-app" ];
        home.programs.zsh.shellAliases = {
          tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        };
      })
      (onlyLinux {
        services.tailscale.enable = true;
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
      })
      (mkIfLinux tsOptions.ssh {
        services.tailscale.extraUpFlags = [ "--ssh" ];
      })
      (mkIfLinux tsOptions.systray {
        systemd.user.services.tailscale-systray = {
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
      })
      (mkIfLinux tsOptions.routing {
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
      })
    ]);
}

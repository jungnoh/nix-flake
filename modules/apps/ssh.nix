{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    onlyLinux
    onlyDarwin
    mkMerge
    ;
in
{
  options.myOptions.ssh = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    tailscaleAccess = mkOption {
      type = types.bool;
      default = false;
      description = "Allow access from IPs in Tailscale subnet";
    };
    passwordLogin = mkOption {
      type = types.bool;
      default = false;
      description = "Allow password logins";
    };
  };

  config =
    let
      sshOptions = config.myOptions.ssh;
    in
    lib.mkIf sshOptions.enable (mkMerge [
      (onlyDarwin {
        services.openssh = {
          enable = true;
        };
      })
      (onlyLinux {
        networking.firewall =
          lib.mkIf (!config.networking.nftables.enable) {
            extraCommands = ''
              iptables -A INPUT -s 192.168.0.0/24 -m state --state NEW -p tcp -dport 22 -j ACCEPT
              ${lib.optionalString sshOptions.tailscaleAccess "iptables -A INPUT -s 100.64.0.0/10 -m state --state NEW -p tcp -dport 22 -j ACCEPT"}
            '';
          }
          // lib.mkIf config.networking.nftables.enable {
            extraInputRules = ''
              ip saddr 192.168.0.0/24 tcp dport 22 accept comment "SSH local access"
              ${lib.optionalString sshOptions.tailscaleAccess ''ip saddr 100.64.0.0/10 tcp dport 22 accept comment "SSH tailscale access"''}
            '';
          };
        services.openssh = {
          enable = true;
          openFirewall = false;
          allowSFTP = false;
          ports = [ 22 ];

          # https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67
          settings = {
            LogLevel = "VERBOSE";
            PermitRootLogin = "no";
            PasswordAuthentication = sshOptions.passwordLogin;
            KbdInteractiveAuthentication = true;

            KexAlgorithms = [
              "curve25519-sha256@libssh.org"
              "ecdh-sha2-nistp521"
              "ecdh-sha2-nistp384"
              "ecdh-sha2-nistp256"
              "diffie-hellman-group-exchange-sha256"
            ];
            Ciphers = [
              "chacha20-poly1305@openssh.com"
              "aes256-gcm@openssh.com"
              "aes128-gcm@openssh.com"
              "aes256-ctr"
              "aes192-ctr"
              "aes128-ctr"
            ];
            Macs = [
              "hmac-sha2-512-etm@openssh.com"
              "hmac-sha2-256-etm@openssh.com"
              "umac-128-etm@openssh.com"
              "hmac-sha2-512"
              "hmac-sha2-256"
              "umac-128@openssh.com"
            ];
          };

          extraConfig = ''
            ClientAliveCountMax 0
            ClientAliveInterval 300

            AllowTcpForwarding no
            AllowAgentForwarding no
            MaxAuthTries 3
            MaxSessions 2
            TCPKeepAlive no
          '';
        };
        services.fail2ban = {
          enable = true;
          maxretry = 10;
          bantime-increment.enable = true;
        };
      })
    ]);
}

[
  (
    { ctx, ... }:
    let
      inherit (ctx) hostname;
    in
    {
      config = {
        homebrew = {
          enable = true;
          prefix = "/opt/homebrew";
          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
            upgrade = true;
          };

          global.brewfile = true;

          extraConfig = ''
            cask_args require_sha: true
          '';

          taps = [ ];
        };

        environment.variables.HOMEBREW_NO_ANALYTICS = "1";
        environment.systemPath = [ "/opt/homebrew/bin" ];

        # TODO: This may be different by device?
        networking.knownNetworkServices = [
          "USB 10/100/1000 LAN"
          "Thunderbolt Bridge"
          "Wi-Fi"
        ];
        networking.dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        networking.hostName = hostname;
        networking.localHostName = hostname;
        networking.computerName = hostname;
      };
    }
  )
]

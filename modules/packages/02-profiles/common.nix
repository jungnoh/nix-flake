# Packages that I'd like to be installed even in least capable machines
# ex. CI Machines, etc.
{
  config,
  lib,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) onlyDarwin onlyLinux;
in
{
  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs.unstable; [
        vim
        nano
        # Tools
        btop
        htop
        fd
        tmux
        # Serialization
        jq
        yq
        # Network
        curl
        wget
        grpcurl
        mtr
        # Other
        aria2
        pv
        # Python
        python3
        virtualenv
        pipx
        uv
      ];
      home.programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        config = {
          global.load_dotenv = true;
        };
      };
    }
    (onlyDarwin {
      home.programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };
    })
    (onlyLinux {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };
    })
  ];
}

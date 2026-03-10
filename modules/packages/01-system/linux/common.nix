{
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) hostname;
in
{
  config = {
    networking.hostName = hostname;

    environment.systemPackages = with pkgs; [
      net-tools
      pciutils
      usbutils
      nvme-cli
    ];

    home.packages = with pkgs; [
      xclip
    ];

    home.shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };
  };
}

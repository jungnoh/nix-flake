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
    networking.nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];

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

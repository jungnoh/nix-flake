{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs.unstable; [
      net-tools
      pciutils
      usbutils
      nvme-cli
    ];

    home.packages = with pkgs.unstable; [
      xclip
    ];

    home.shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };
  };
}

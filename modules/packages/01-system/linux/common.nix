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
  };
}

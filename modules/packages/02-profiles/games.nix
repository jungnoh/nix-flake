{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs.unstable; [
      proton-ge-bin
    ];
  };
  environment.systemPackages = with pkgs.unstable; [
    # Install dw-proton
    protonplus
  ];
}

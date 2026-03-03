# Tools needed specifically for cloud/DevOps work
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    # These are installed as home packages because we need these only for clients
    home.packages = with pkgs; [
      redis
      postgresql
      mysql84
    ];
  };
}

{
  config,
  pkgs,
  ctx,
  ...
}:
let
  inherit (ctx) username;
in
{
  users.defaultUserShell = pkgs.unstable.zsh;
}

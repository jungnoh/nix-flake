# Common applications that are used in a desktop environment
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
    asdf-vm
    jetbrains-toolbox
    brotli
    cloc
    nil
    opencode
    claude-code
    sqlitebrowser
    insomnia
  ];
}

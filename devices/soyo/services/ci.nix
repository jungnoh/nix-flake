{ ... }:
{ pkgs, config, ... }:
{
  users.groups.ga-pekora = { };
  users.users.ga-pekora = {
    isSystemUser = true;
    group = "ga-pekora";
    useDefaultShell = true;
    extraGroups = [ "podman" ];
  };
  age.secrets.ga-pekora-token.file = ../../secrets/soyo-github-runner-pekora.age;
  services.github-runners = {
    pekora = {
      enable = true;
      name = "pekora-cs";
      user = "ga-pekora";
      tokenFile = config.age.secrets.ga-pekora-token.path;
      url = "https://github.com/jungnoh/pekora-cs";
      extraPackages = with pkgs; [ docker ];
    };
  };
}

{ config, options, lib, pkgs, ... }:
{
  config = {
    home.programs.git = {
      enable = true;
      userName = "Junghoon Noh";
      userEmail = "jungnoh.dev@gmail.com";
      extraConfig = {
        checkout.defaultRemote = "origin";
        pager.diff = "delta --plus-style 'syntax #205820'";
        pull.ff = "only";
        push.autoSetupRemote = "true";
        rerere.enabled = "true";
      };
    };

    home.programs.zsh.shellAliases = {
      gf = "git fetch";
      gco = "git checkout";
      gpl = "git pull";
      gph = "git push";
      gsh = "git stash";
      gsp = "git stash pop";
    };

    home.packages = with pkgs; [
      git-lfs
      rs-git-fsmonitor
      delta
    ];
  };
}
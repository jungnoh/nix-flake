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
        core.editor = "vim";
      };
    };

    home.programs.zsh.shellAliases = {
      git = "LC_ALL=en_US.UTF-8 git";
      gf = "git fetch -p";
      gco = "git checkout";
      gpl = "git pull";
      gph = "git push";
      gsh = "git stash";
      gsp = "git stash pop";
      glg = "git log";
      grb = "git rebase";
      grbi = "git rebase -i";
    };

    home.packages = with pkgs; [
      git-lfs
      rs-git-fsmonitor
      delta
    ];
  };
}
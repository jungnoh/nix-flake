{ config, options, lib, pkgs, ... }:
let 
  gitAliasRepo = pkgs.fetchFromGitHub {
    owner = "GitAlias";
    repo = "gitalias";
    rev = "b56365b13a318b544ecb0df112bbbd12c4e61bce";
    sha256 = "sha256-CdjSugU06nOiRBWx/CrLKlLRUi3OQWAuhe/pV+BgRb8=";
  };
in {
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
      includes = [
        { path = "${gitAliasRepo}/gitalias.txt"; }
      ];
    };

    home.programs.zsh.shellAliases = {
      git = "LC_ALL=en_US.UTF-8 git";
    };

    home.packages = with pkgs; [
      git-lfs
      rs-git-fsmonitor
      delta
    ];
  };
}

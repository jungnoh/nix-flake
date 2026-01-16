{ config, options, lib, pkgs, ... }:
let
  gitAliasRepo = pkgs.fetchFromGitHub {
    owner = "GitAlias";
    repo = "gitalias";
    rev = "b56365b13a318b544ecb0df112bbbd12c4e61bce";
    sha256 = "sha256-CdjSugU06nOiRBWx/CrLKlLRUi3OQWAuhe/pV+BgRb8=";
  };
in
{
  config = {
    home.programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Junghoon Noh";
          email = "jungnoh.dev@gmail.com";
        };
        checkout = {
          defaultRemote = "origin";
        };
        rerere = {
          enabled = "true";
          autoupdate = "true";
        };
        pager.diff = "delta --plus-style 'syntax #205820'";
        pull.ff = "only";
        push.autoSetupRemote = "true";
        core.editor = "vim";
        # https://news.hada.io/topic?id=19441
        column.ui = "auto";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        init.defaultBranch = "main";
        diff.algorithm = "histogram";
        diff.colorMoved = "plain";
        diff.mnemonicPrefix = "true";
        diff.renames = "true";
        push.default = "simple";
        push.followTags = "true";
        fetch.prune = "true";
        fetch.pruneTags = "true";
        fetch.all = "true";
        help.autocorrect = "prompt";
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

{ config, lib, self, ... }:

let
  cfg = config.dotfyls.programs.git;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "git" ]
      [ "programs" "git" ])
  ];

  options.dotfyls.programs.git.enable = lib.mkEnableOption "Git" // { default = true; };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      ga = "git add";
      gaa = "git add --all";

      gb = "git branch";

      gc = "git commit";
      gca = "git commit --amend";

      gco = "git checkout";

      gd = "git diff";
      gds = "git diff --staged";
      gdup = "git log -p @{push}..";

      gl = "git log";
      glup = "git log @{push}..";

      gm = "git merge";

      gp = "git push";
      gpf = "git push --force-with-lease";

      grc = "git rebase --continue";
      gri = "git rebase --interactive";

      gs = "git status";
    };

    programs.git = {
      enable = true;
      userName = "xarvex";
      userEmail = "gitlab-github.8qs1z@slmail.me";
      signing = {
        signByDefault = true;
        key = null; # Allow GnuPG to decide.
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        advice = {
          addIgnoredFile = false;
        };
      };
    };
  };
}

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

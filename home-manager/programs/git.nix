{ config, lib, ... }:

{
  options.dotfyls.programs.git.enable = lib.mkEnableOption "Git" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.git.enable {
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

    dotfyls.persist.directories = [ ".config/systemd" ]; # maintenance timers
  };
}

{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.git;
in
{
  imports = [
    ./difftastic.nix

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "git"
      ]
      [
        "programs"
        "git"
      ]
    )
  ];

  options.dotfyls.programs.git = {
    enable = lib.mkEnableOption "Git" // {
      default = true;
    };
    key = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "The default GPG signing key fingerprint.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.files.".cache/pre-commit".cache = true;

    home.shellAliases = {
      ga = "git add";
      gai = "git add -N";
      gaa = "git add -A";
      gaai = "git add -AN";

      gb = "git branch";

      gc = "git commit";
      gca = "git commit -a";
      gcam = "git commit -am";
      gcm = "git commit -m";

      gco = "git checkout";

      gd = "git diff";
      gds = "git diff --staged";
      gdp = "git log -p @{push}..";

      gl = "git log";
      glp = "git log @{push}..";

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
      userEmail = "dev.ellz6@xarvex.simplelogin.com";
      signing = {
        inherit (cfg) key;

        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        advice.addIgnoredFile = false;
      };
    };
  };
}

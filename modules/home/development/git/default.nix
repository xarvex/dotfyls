{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.git;
in
{
  imports = [
    ./difftastic.nix
    ./lazygit.nix

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "development"
        "git"
      ]
      [
        "programs"
        "git"
      ]
    )
  ];

  options.dotfyls.development.git = {
    enable = lib.mkEnableOption "Git" // {
      default = true;
    };
    key = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "0046A18B1037C201";
      description = "The default GPG signing key fingerprint.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/pre-commit".cache = true;

    home.shellAliases = {
      ga = "git add";
      gap = "git add -p";
      gaa = "git add -A";
      gaap = "git add -Ap";

      gb = "git branch";

      gc = "git commit";
      gca = "git commit -a";
      gcm = "git commit -m";
      gcam = "git commit -am";

      gco = "git checkout";
      gcob = "git checkout -b";

      gd = "git diff";
      gds = "git diff --staged";

      gl = "git log";
      glo = "git log --oneline";

      gm = "git merge";

      gp = "git push";
      gpf = "git push --force-with-lease";

      grbc = "git rebase --continue";
      grbi = "git rebase -i";

      gs = "git status -sb";
    };

    programs.git = {
      enable = true;

      userName = "Xarvex";
      userEmail = "dev.ellz6@xarvex.simplelogin.com";
      signing = {
        signByDefault = true;
        inherit (cfg) key;
      };

      aliases = {
        last = "log -1 --patch --ext-diff";
        patch = "diff --patch --no-ext-diff";
        tree = "log --all --graph";
        unpushed = "log @{push}.. --patch --ext-diff";
      };

      extraConfig = {
        advice = {
          addEmptyPathspec = false;
          addIgnoredFile = false;
        };
        format.pretty = "format:%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset";
        init.defaultBranch = "main";
      };
    };
  };
}

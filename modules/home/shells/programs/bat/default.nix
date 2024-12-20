{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.bat;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "bat" ] [ "programs" "bat" ])
  ];

  options.dotfyls.shells.programs.bat = {
    enable = lib.mkEnableOption "bat" // {
      default = cfg'.enableFun;
    };
    enablePager = lib.mkEnableOption "bat as pager" // {
      default = true;
    };
    enableManPager = lib.mkEnableOption "bat as man pager" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/bat".cache = true;

    home = {
      sessionVariables = {
        PAGER = lib.mkIf cfg.enablePager "bat -p";

        # From: https://github.com/sharkdp/bat/pull/2858
        MANPAGER = lib.mkIf cfg.enableManPager "${''sh -c 'sed -ue \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -plman''}'";
      };

      shellAliases = {
        cat = "bat";

        watchfile = "watch -cn1 -x bat -f --theme ansi";
      };
    };

    programs.bat = {
      enable = true;

      config.style = "full";
    };
  };
}

{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.bat;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "bat"
      ]
      [
        "programs"
        "bat"
      ]
    )
  ];

  options.dotfyls.programs.bat = {
    enable = lib.mkEnableOption "bat" // {
      default = true;
    };
    enablePager = lib.mkEnableOption "bat as pager" // {
      default = true;
    };
    enableManPager = lib.mkEnableOption "bat as man pager" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".cache/bat" ];

    home = {
      sessionVariables = {
        PAGER = lib.mkIf cfg.enablePager "bat -p";

        # From: https://github.com/sharkdp/bat/pull/2858
        MANPAGER = lib.mkIf cfg.enableManPager ''
          sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'
        '';
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

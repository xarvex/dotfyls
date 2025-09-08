{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.bat;

  # Do not want to log out when bat updates.
  binPath = "/etc/profiles/per-user/${config.home.username}/bin/";

  # From: https://github.com/sharkdp/bat/pull/2858
  manpager = pkgs.writers.writeDash "dotfyls-bat-manpager" ''
    ${lib.getExe pkgs.gnused} --unbuffered --expression="s/\\x1B\[[0-9;]*m//g; s/.\\x08//g" \
        | ${binPath}bat --plain --language man
  '';
in
{
  options.dotfyls.shells.tools.bat = {
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
        PAGER = lib.mkIf cfg.enablePager "${binPath}bat --plain";
        MANPAGER = lib.mkIf cfg.enableManPager manpager;
      };

      shellAliases = {
        cat = "bat";

        watchfile = "watch -cn1 -x bat -f --theme ansi";
      };
    };

    programs.bat = {
      enable = true;

      config.style = "-changes,-numbers";
    };
  };
}

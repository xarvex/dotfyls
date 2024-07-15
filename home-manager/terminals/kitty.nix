{ config, lib, pkgs, ... }:

{
  options.dotfyls.terminals.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.dotfyls.terminals.kitty.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = config.dotfyls.fonts.monospace.name;
        size = config.dotfyls.terminals.fontSize;
      };
      settings = {
        update_check_interval = 0;
        scrollback_lines = 10000;
        background_opacity = toString 0.85;
      };
      extraConfig = ''
        include themes.conf
      '';
    };

    dotfyls = {
      terminals = rec {
        start.kitty = lib.getExe pkgs.kitty;
        exec.kitty = start.kitty;
      };
      persist.cacheDirectories = [ ".config/kitty" ];
    };
  };
}

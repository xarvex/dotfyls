{ config, lib, pkgs, ... }:

{
  options.dotfyls.terminals.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.dotfyls.terminals.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        update_check_interval = 0;
        scrollback_lines = 10000;
        background_opacity = toString 0.85;
      };
    };

    dotfyls.terminals = rec {
      start.kitty = lib.getExe pkgs.kitty;
      exec.kitty = start.kitty;
    };
  };
}

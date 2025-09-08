{ config, lib, ... }:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.alacritty;
in
{
  options.dotfyls.terminals.alacritty.enable = lib.mkEnableOption "Alacritty";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          decorations = "None";
          inherit (cfg') opacity;
        };
        scrolling.history = cfg'.scrollback;
        font.size = cfg'.fontSize;
        cursor.style = {
          shape = "Beam";
          blinking = "On";
        };
        mouse.hide_when_typing = true;
      };
    };
  };
}

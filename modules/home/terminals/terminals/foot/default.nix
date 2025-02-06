{ config, lib, ... }:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.terminals.foot;
in
{
  options.dotfyls.terminals.terminals.foot.enable = lib.mkEnableOption "foot";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.foot = {
      enable = true;

      settings = {
        main.font = "monospace:size=${toString cfg'.fontSize}";
        scrollback.lines = cfg'.scrollback;
        cursor = {
          style = "beam";
          blink = "yes";
        };
        mouse.hide-when-typing = "yes";
        colors.alpha = cfg'.opacity;
      };
    };
  };
}

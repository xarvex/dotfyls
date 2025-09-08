{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
  hmCfg = config.hm.dotfyls.desktops.hyprland;
in
{
  options.dotfyls.desktops.hyprland.enable = lib.mkEnableOption "Hyprland" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.hyprland = {
      enable = true;

      withUWSM = false;
    };
  };
}

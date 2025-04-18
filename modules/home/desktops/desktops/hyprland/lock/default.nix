{ config, lib, ... }:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.desktops.hyprland;
  cfg = cfg'.lock;
in
{
  options.dotfyls.desktops.desktops.hyprland.lock.enable = lib.mkEnableOption "hyprlock" // {
    default = true;
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    programs.hyprlock = {
      enable = true;

      settings = {
        general.disable_loading_bar = true;
        # TODO: theme
      };
    };
  };
}

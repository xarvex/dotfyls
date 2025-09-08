{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprlock;
in
{
  options.dotfyls.desktops.hyprlock.enable = lib.mkEnableOption "hyprlock";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.hyprlock = {
      enable = true;

      settings = {
        general.disable_loading_bar = true;
        # TODO: theme
      };
    };

    wayland.windowManager.hyprland.settings.permission = [
      "${lib.escapeRegex (self.lib.getCfgExe config.programs.hyprlock)}, screencopy, allow"
    ];
  };
}

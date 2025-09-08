# TODO: Replace with dotpanel.
{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.rofi;
in
{
  options.dotfyls.desktops.rofi.enable = lib.mkEnableOption "Rofi";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;

      terminal = lib.mkIf config.xdg.terminal-exec.enable (self.lib.getCfgExe config.xdg.terminal-exec);
    };

    wayland.windowManager.hyprland.settings.bind =
    [
      "SUPER_SHIFT, Return, exec, ${self.lib.getCfgExe config.programs.rofi} -show drun -show-icons${lib.optionalString cfg'.wayland.uwsm.enable " -run-command '${cfg'.wayland.uwsm.prefix}{cmd}'"}"
    ]
    ++ lib.optional config.services.cliphist.enable "SUPER_SHIFT, V, exec, ${self.lib.getCfgExe config.programs.rofi} -modi clipboard:cliphist-rofi-img -show clipboard -show-icons";
  };
}

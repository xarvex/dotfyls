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

      terminal = lib.mkIf config.dotfyls.terminals.xdg-terminal-exec.enable (
        self.lib.getCfgExe config.dotfyls.terminals.xdg-terminal-exec
      );
    };
  };
}

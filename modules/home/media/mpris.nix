{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpris;
in
{
  options.dotfyls.media.mpris = {
    enable = lib.mkEnableOption "MPRIS2" // {
      default = config.dotfyls.desktops.enable;
    };
    bluetoothProxy = lib.mkEnableOption "MPRIS2 proxy for Bluetooth MIDI" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services = {
      playerctld.enable = true;
      mpris-proxy.enable = cfg.bluetoothProxy;
    };

    wayland.windowManager.hyprland.settings.bindl =
      let
        playerctl = self.lib.getCfgExe config.services.playerctld;
      in
      [
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPlay, exec, ${playerctl} play-pause"
        ", XF86AudioPrev, exec, ${playerctl} previous"
      ];
  };
}

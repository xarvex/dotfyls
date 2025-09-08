{
  config,
  lib,
  osConfig ? null,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
  osCfg = if osConfig == null then null else osConfig.dotfyls.media.pipewire;
in
{
  options.dotfyls.media.pipewire.enable = lib.mkEnableOption "PipeWire" // {
    default = if osCfg == null then config.dotfyls.desktops.enable else osCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/state/wireplumber" = {
      mode = "0700";
      cache = true;
    };

    wayland.windowManager.hyprland.settings =
      let
        wpctl =
          if osConfig != null && osConfig.home-manager.useGlobalPkgs then
            self.lib.getCfgExe' osConfig.services.pipewire.wireplumber "wpctl"
          else
            "${lib.optionalString (!config.targets.genericLinux.enable) "/run/current-system/sw/bin/"}wpctl";
      in
      {
        bindl = [
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        bindle = [
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ];
      };
  };
}

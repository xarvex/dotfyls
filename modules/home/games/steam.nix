{ config, lib, ... }:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.steam;
in
{
  options.dotfyls.games.steam.enable = lib.mkEnableOption "Steam" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".steam".cache = true;
      ".local/share/Steam" = {
        mode = "0700";
        cache = true;
      };

      ".config/StardewValley".cache = true;
      ".config/StardewValley/Saves" = {
        persist = true;
        sync = {
          enable = true;
          rescan = 0;
          watch.delay = 15 * 60;
          order = "newestFirst";
        };
      };
    };

    home.sessionVariables = {
      PROTON_ENABLE_WAYLAND = 1;
      PROTON_ENABLE_HDR = 1;
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "fullscreen, class:steam_app_1361210, title:Warhammer 40,000: Darktide"
    ];
  };
}

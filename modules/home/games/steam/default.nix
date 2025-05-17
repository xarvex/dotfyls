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
    dotfyls = {
      file = {
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

      mime-apps.extraSchemes = {
        steam = "steam.desktop";
        steamlink = "steam.desktop";
      };
    };
  };
}

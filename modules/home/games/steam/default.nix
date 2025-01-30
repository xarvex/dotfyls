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
      };

      mime-apps.extraSchemes = {
        steam = "steam.desktop";
        steamlink = "steam.desktop";
      };
    };
  };
}

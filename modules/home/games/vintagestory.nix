{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.vintagestory;
in
{
  options.dotfyls.games.vintagestory.enable = lib.mkEnableOption "Vintage Story" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".config/VintagestoryData".cache = true;
      ".config/VintagestoryData/Saves" = {
        persist = true;
        sync = {
          enable = true;
          rescan = 0;
          watch.delay = 15 * 60;
          order = "newestFirst";
        };
      };
    };

    home.packages = with pkgs; [ vintagestory ];
  };
}

{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.steam;
in
{
  options.dotfyls.media.steam.enable = lib.mkEnableOption "Steam" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files.cacheDirectories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}
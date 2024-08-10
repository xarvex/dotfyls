{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.steam;
in
{
  options.dotfyls.programs.steam.enable = lib.mkEnableOption "Steam" // { default = config.dotfyls.desktops.enable; };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}

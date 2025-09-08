{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.monitor;
  cfg = cfg'.mission-center;
in
{
  options.dotfyls.management.monitor.mission-center.enable = lib.mkEnableOption "Mission Center" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = with pkgs; [ mission-center ]; };
}

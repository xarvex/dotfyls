{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.intel;
  osCfg = if osConfig == null then null else osConfig.dotfyls.graphics.intel;
in
{
  options.dotfyls.graphics.intel.enable = lib.mkEnableOption "Intel" // {
    default = osCfg != null && osCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = lib.optional cfg'.enableTools pkgs.intel-gpu-tools;
  };
}

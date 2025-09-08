{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.nvidia;
  osCfg = if osConfig == null then null else osConfig.dotfyls.graphics.nvidia;
in
{
  options.dotfyls.graphics.nvidia.enable = lib.mkEnableOption "Nvidia" // {
    default = osCfg != null && osCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".cache/nvidia".mode = "0700";
      ".cache/nvidia/GLCache" = {
        mode = "0700";
        cache = true;
      };
    };
  };
}

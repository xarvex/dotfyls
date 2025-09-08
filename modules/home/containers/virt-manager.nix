{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.virt-manager;
  osCfg = if osConfig == null then null else osConfig.dotfyls.containers.virt-manager;
in
{
  options.dotfyls.containers.virt-manager.enable = lib.mkEnableOption "virt-manager" // {
    default = osCfg != null && osCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/virt-manager" = {
      mode = "0700";
      cache = true;
    };
  };
}

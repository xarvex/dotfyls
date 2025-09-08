{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.management.rgb;
  osCfg = if osConfig == null then null else osConfig.dotfyls.management.rgb;
in
{
  options.dotfyls.management.rgb.enable = lib.mkEnableOption "OpenRGB" // {
    default = osCfg != null && osCfg.enable;
  };

  # TODO: Confirm permissions.
  config = lib.mkIf cfg.enable { dotfyls.file.".config/OpenRGB".persist = true; };
}

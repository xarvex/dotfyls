{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.graphics;
in
{
  options.dotfyls.graphics.graphics.nvidia.enable =
    lib.mkEnableOption "Nvidia graphics"
    // (lib.optionalAttrs (osConfig != null) {
      default = osConfig.dotfyls.graphics.graphics.nvidia.enable;
    });

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".cache/nvidia".mode = "0700";
      ".cache/nvidia/GLCache" = {
        mode = "0700";
        cache = true;
      };
    };
  };
}

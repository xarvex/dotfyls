{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.programs.virt-manager;
in
{
  options.dotfyls.programs.virt-manager.enable =
    lib.mkEnableOption "virt-manager"
    // lib.optionalAttrs (osConfig != null) {
      default = osConfig.dotfyls.programs.virt-manager.enable;
    };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/virt-manager" = {
      mode = "0700";
      cache = true;
    };
  };
}

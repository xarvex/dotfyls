{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfyls.graphics;
in
{
  options.dotfyls.graphics.enable = lib.mkEnableOption "graphics" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { dotfyls.file.".cache/mesa_shader_cache_db".cache = true; };
}

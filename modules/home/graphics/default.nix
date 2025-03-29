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
  imports = [ ./nvidia.nix ];

  options.dotfyls.graphics.enable = lib.mkEnableOption "graphics" // {
    default =
      if (osConfig == null) then config.dotfyls.desktops.enable else osConfig.dotfyls.graphics.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/share/vulkan/implicit_layer.d".cache = true;
      ".cache/mesa_shader_cache_db".cache = true;
    };
  };
}

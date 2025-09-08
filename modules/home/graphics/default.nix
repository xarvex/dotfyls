{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.graphics;
  osCfg = if osConfig == null then null else osConfig.dotfyls.graphics;
in
{
  imports = [
    ./brightness.nix
    ./intel.nix
    ./nvidia.nix
  ];

  options.dotfyls.graphics = {
    enable = lib.mkEnableOption "graphics" // {
      default = if osCfg == null then config.dotfyls.desktops.enable else osCfg.enable;
    };

    enableTools = lib.mkEnableOption "graphics tools";
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/share/vulkan/implicit_layer.d".cache = true;
      ".cache/mesa_shader_cache".cache = true;
    };

    home.packages = lib.optionals cfg.enableTools (
      with pkgs;
      [
        libdrm
        libva-utils
        mesa-demos
        vdpauinfo
        vulkan-tools
        wgpu-utils
      ]
    );
  };
}

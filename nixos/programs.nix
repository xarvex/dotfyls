{ config, lib, ... }:

{
  options.dotfyls.programs = {
    gvfs.enable = lib.mkEnableOption "GVfs" // { default = true; };
  };

  config = let cfg = config.dotfyls.programs; in lib.mkMerge [
    (lib.mkIf cfg.gvfs.enable {
      services.gvfs.enable = true;
    })
  ];
}

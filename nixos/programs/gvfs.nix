{ config, lib, ... }:

{
  options.dotfyls.programs.gvfs = {
    enable = lib.mkEnableOption "GVfs" // { default = true; };
  };

  config = lib.mkIf config.dotfyls.programs.gvfs.enable {
    services.gvfs.enable = true;
  };
}

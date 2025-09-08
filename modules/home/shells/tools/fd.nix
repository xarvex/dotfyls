{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.fd;
in
{
  options.dotfyls.shells.tools.fd.enable = lib.mkEnableOption "fd" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable {
    programs.fd = {
      enable = true;

      hidden = true;
    };
  };
}

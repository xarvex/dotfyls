{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.portal;
  hmCfg = config.hm.dotfyls.desktops.portal;
in
{
  options.dotfyls.desktops.portal.enable = lib.mkEnableOption "XDG Desktop Portal" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    environment.pathsToLink = [ "/share/xdg-desktop-portal" ];
  };
}

# TODO: Replace with dotpanel.
{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.dunst;
in
{
  options.dotfyls.desktops.dunst.enable = lib.mkEnableOption "Dunst";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.dunst = {
      enable = true;
      # TODO: theme
    };
  };
}

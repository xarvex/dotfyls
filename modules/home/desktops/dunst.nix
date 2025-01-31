# TODO: Replace with dotpanel.
{ config, lib, ... }:

let
  cfg = config.dotfyls.desktops.dunst;
in
{
  options.dotfyls.desktops.dunst.enable = lib.mkEnableOption "Dunst";

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      # TODO: theme
    };
  };
}

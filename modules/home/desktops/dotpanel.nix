{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.dotfyls.desktops.dotpanel;
in
{
  imports = [ inputs.dotpanel.homeManagerModules.dotpanel ];

  options.dotfyls.desktops.dotpanel.enable = lib.mkEnableOption "dotpanel";

  config = lib.mkIf cfg.enable {
    programs.dotpanel.enable = true;

    wayland.windowManager.hyprland.settings.layerrule = [
      "blur, dotpanel-.+"
      "ignorezero, dotpanel-.+"
    ];
  };
}

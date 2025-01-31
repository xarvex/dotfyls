{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
  hmCfg = config.hm.dotfyls.desktops.desktops.hyprland;
in
{
  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // {
      default = hmCfg.enable;
    };
    lock.enable = lib.mkEnableOption "hyprlock" // {
      default = hmCfg.lock.enable;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.hyprland.enable = true;

    security.pam.services.hyprlock.u2fAuth =
      lib.mkIf cfg.lock.enable config.security.pam.services.login.u2fAuth;
  };
}

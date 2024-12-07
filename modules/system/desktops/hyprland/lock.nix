{ config, lib, ... }:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.desktops.hyprland;
  cfg = cfg'.lock;
  hmCfg = config.hm.dotfyls.desktops.desktops.hyprland.lock;
in
{
  options.dotfyls.desktops.desktops.hyprland.lock.enable = lib.mkEnableOption "hyprlock" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    security.pam.services.hyprlock.u2fAuth = config.security.pam.services.login.u2fAuth;
  };
}

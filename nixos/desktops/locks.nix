{ config, lib, ... }:

let
  cfg = config.dotfyls.desktops.locks;
  hmCfg = config.hm.dotfyls.desktops.locks;
in
{
  options.dotfyls.desktops.locks = {
    hyprlock.enable = lib.mkEnableOption "hyprlock" // {
      default = hmCfg.locks.hyprlock.enable;
    };
    swaylock.enable = lib.mkEnableOption "swaylock" // {
      default = hmCfg.locks.swaylock.enable;
    };
  };

  config = lib.mkIf config.dotfyls.desktops.enable (
    lib.mkMerge [
      (lib.mkIf cfg.hyprlock.enable {
        security.pam.services.hyprlock.u2fAuth = config.security.pam.services.login.u2fAuth;
      })

      (lib.mkIf cfg.swaylock.enable {
        security.pam.services.swaylock.u2fAuth = config.security.pam.services.login.u2fAuth;
      })
    ]
  );
}

{ config, lib, ... }:

let
  cfg = config.dotfyls.security.apparmor;
in
{
  options.dotfyls.security.apparmor.enable = lib.mkEnableOption "AppArmor" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.dbus.apparmor = "enabled";

    security.apparmor = {
      enable = true;

      killUnconfinedConfinables = true;
    };
  };
}

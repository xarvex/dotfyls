{ config, lib, ... }:

let
  cfg = config.dotfyls.management.geolocation;
in
{
  options.dotfyls.management.geolocation = {
    enable = lib.mkEnableOption "geolocation" // {
      default = config.dotfyls.meta.machine.isLaptop;
    };
    automatic-timezone = lib.mkEnableOption "automatic timezone" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      geoclue2.enable = true;
      automatic-timezoned.enable = cfg.automatic-timezone;
    };
  };
}

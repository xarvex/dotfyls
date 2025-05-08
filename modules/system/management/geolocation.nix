{ config, lib, ... }:

let
  cfg = config.dotfyls.management.geolocation;
in
{
  options.dotfyls.management.geolocation.enable = lib.mkEnableOption "geolocation" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { services.geoclue2.enable = true; };
}

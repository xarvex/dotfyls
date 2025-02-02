{ config, lib, ... }:

let
  cfg = config.dotfyls.management.time;
in
{
  options.dotfyls.management.time.automatic-zone = lib.mkEnableOption "automatic timezone" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkMerge [
    { time.timeZone = lib.mkDefault "America/Chicago"; }

    (lib.mkIf cfg.automatic-zone {
      dotfyls.management.geolocation.enable = true;

      services.automatic-timezoned.enable = true;
    })
  ];
}

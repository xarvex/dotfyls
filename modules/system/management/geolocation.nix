{ config, lib, ... }:

let
  cfg = config.dotfyls.management.geolocation;
in
{
  options.dotfyls.management.geolocation.enable = lib.mkEnableOption "geolocation" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    services.geoclue2 = {
      enable = true;
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      submissionUrl = "https://api.beacondb.net/v2/geosubmit";
    };
  };
}

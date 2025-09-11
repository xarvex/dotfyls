{ config, lib, ... }:

let
  cfg = config.dotfyls.boot.firmware;
in
{
  options.dotfyls.boot.firmware = {
    enable = lib.mkEnableOption "firmware" // {
      default = true;
    };
    updater = lib.mkEnableOption "firmware updater" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        hardware.enableRedistributableFirmware = cfg.enable;

        services.fwupd.enable = cfg.updater;
      }

      (lib.mkIf config.services.fwupd.enable {
        dotfyls.file = {
          "/var/lib/fwupd" = {
            user = "fwupd-refresh";
            cache = true;
          };
          "/var/cache/fwupd".cache = true;
        };
      })
    ]
  );
}

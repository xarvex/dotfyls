{ config, lib, ... }:

let
  cfg' = config.dotfyls.files.systems.systems.zfs;
  cfg = cfg'.autosnap;
in
{
  options.dotfyls.files.systems.systems.zfs.autosnap.enable =
    lib.mkEnableOption "Sanoid ZFS autosnap"
    // {
      default = true;
    };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/cache/private/sanoid" = {
      user = "sanoid";
      cache = true;
    };

    services.sanoid = {
      enable = true;
      interval = "*:0/15";

      templates.default = {
        daily_hour = 0;
        daily_min = 0;

        weekly_wday = 7;
        weekly_hour = 0;
        weekly_min = 0;
      };
      datasets."zroot/persist" = {
        frequently = 8;
        hourly = 48;
        daily = 14;
        weekly = 4;
        monthly = 3;
      };
    };

    users = {
      users.sanoid = {
        isSystemUser = true;
        group = "sanoid";
      };
      groups.sanoid = { };
    };
  };
}

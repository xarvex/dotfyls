{ config, lib, ... }:

let
  cfg' = config.dotfyls.management.power;
  cfg = cfg'.upower;
in
{
  options.dotfyls.management.power.upower.enable = lib.mkEnableOption "UPower" // {
    default = cfg'.battery;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file."/var/lib/upower".cache = true;

    services.upower = {
      enable = true;
      noPollBatteries = true;
    };
  };
}

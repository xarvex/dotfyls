{ config, lib, ... }:

let
  cfg' = config.dotfyls.power;
  cfg = cfg'.upower;
in
{
  options.dotfyls.power.upower.enable = lib.mkEnableOption "UPower" // {
    default = cfg'.management.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file."/var/lib/upower".cache = true;

    services.upower = {
      enable = true;
      noPollBatteries = true;
    };
  };
}

{ config, lib, ... }:

let
  cfg = config.dotfyls.power.management;
in
{
  options.dotfyls.power.management.enable = lib.mkEnableOption "power management";

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}

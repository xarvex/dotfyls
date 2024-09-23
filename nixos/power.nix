{ config, lib, ... }:

let
  cfg = config.dotfyls.power;
in
{
  options.dotfyls.power = {
    suspend = {
      enable = lib.mkEnableOption "suspend" // {
        default = true;
      };
      light = lib.mkEnableOption "lighter suspend method";
    };
    management = lib.mkEnableOption "power management";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.suspend.enable {
      boot.kernelParams = [ "mem_sleep_default=${if cfg.suspend.light then "s2idle" else "deep"}" ];
    })
    (lib.mkIf (!cfg.suspend.enable) {
      # TODO: disable if false
    })

    (lib.mkIf cfg.management {
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

      powerManagement.enable = true;
    })
  ];
}

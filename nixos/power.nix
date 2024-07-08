{ config, lib, ... }:

{
  options.dotfyls.power = {
    suspend = {
      enable = lib.mkEnableOption "suspend" // { default = true; };
      light = lib.mkEnableOption "lighter suspend method";
    };
    management = lib.mkEnableOption "power management";
  };

  config =
    let
      cfg = config.dotfyls.power;
    in
    lib.mkMerge [
      (lib.mkIf cfg.suspend.enable {
        boot.kernelParams = [ "mem_sleep_default=${if cfg.suspend.light then "s2idle" else "deep"}" ];
      })
      (lib.mkIf (!cfg.suspend.enable) {
        # TODO: disable if false
      })

      (lib.mkIf cfg.management {
        powerManagement.enable = true;
        services.tlp = {
          enable = true;
          # TODO: further power management
        };
      })
    ];
}

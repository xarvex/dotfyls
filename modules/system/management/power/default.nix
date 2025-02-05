{ config, lib, ... }:

let
  cfg = config.dotfyls.management.power;
in
{
  imports = [
    ./tlp.nix
    ./upower.nix
  ];

  options.dotfyls.management.power = {
    battery = lib.mkEnableOption "battery";
    suspend = {
      enable = lib.mkEnableOption "suspend" // {
        default = true;
      };
      light = lib.mkEnableOption "lighter suspend method";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.suspend.enable {
      boot.kernelParams = [ "mem_sleep_default=${if cfg.suspend.light then "s2idle" else "deep"}" ];
    })
    (lib.mkIf (!cfg.suspend.enable) {
      systemd.targets = {
        hibernate.enable = false;
        hybrid-sleep.enable = false;
        sleep.enable = false;
        suspend.enable = false;
      };
    })
  ];
}

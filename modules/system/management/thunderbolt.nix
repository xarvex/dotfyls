{ config, lib, ... }:

let
  cfg = config.dotfyls.management.thunderbolt;
in
{
  options.dotfyls.management.thunderbolt.enable = lib.mkEnableOption "Thunderbolt" // {
    default = config.dotfyls.meta.machine.isLaptop;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file."/var/lib/boltd/devices".cache = true;

    services.hardware.bolt.enable = true;
  };
}

{ config, lib, ... }:

let
  cfg = config.dotfyls.management.thunderbolt;
in
{
  options.dotfyls.management.thunderbolt.enable = lib.mkEnableOption "Thunderbolt" // {
    default = builtins.elem "thunderbolt" config.boot.initrd.availableKernelModules;
  };

  config = lib.mkIf cfg.enable { services.hardware.bolt.enable = true; };
}

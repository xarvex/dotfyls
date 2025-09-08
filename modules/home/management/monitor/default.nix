{ config, lib, ... }:

{
  imports = [
    ./btop.nix
    ./mission-center.nix
    ./nvtop.nix
  ];

  options.dotfyls.management.monitor.enable = lib.mkEnableOption "monitoring" // {
    default = !config.dotfyls.meta.machine.remote;
  };
}

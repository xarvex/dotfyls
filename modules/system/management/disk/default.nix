{ config, lib, ... }:

let
  hmCfg = config.hm.dotfyls.management.disk;
in
{
  imports = [
    ./benchmark.nix
    ./partitions.nix
  ];

  options.dotfyls.management.disk.enable = lib.mkEnableOption "disk management" // {
    default = hmCfg.enable;
  };
}

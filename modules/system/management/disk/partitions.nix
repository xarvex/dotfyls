{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.disk;
  cfg = cfg'.partitions;
in
{
  options.dotfyls.management.disk.partitions.enable = lib.mkEnableOption "GParted" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [ gparted ];
  };
}

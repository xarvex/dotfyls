{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.disk;
  cfg = cfg'.benchmark;
in
{
  options.dotfyls.management.disk.benchmark.enable = lib.mkEnableOption "KDiskMark" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [ kdiskmark ];

    services.dbus.packages = with pkgs; [ kdiskmark ];
  };
}

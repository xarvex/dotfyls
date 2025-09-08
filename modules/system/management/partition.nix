{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.management.partition;
in
{
  options.dotfyls.management.partition.enable = lib.mkEnableOption "partitioning" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ gparted ]; };
}

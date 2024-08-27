{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.mpris-proxy;
in
{
  options.dotfyls.programs.mpris-proxy.enable = lib.mkEnableOption "MPRIS2 proxy" // { default = config.dotfyls.desktops.enable; };

  config = lib.mkIf cfg.enable {
    services.mpris-proxy.enable = true;
  };
}

{ config, lib, ... }:

let
  cfg = config.dotfyls.security.proton;
in
{
  imports = [
    ./mail
    ./pass
    ./vpn
  ];

  options.dotfyls.security.proton.enable = lib.mkEnableOption "Proton services" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { dotfyls.persist.cacheDirectories = [ ".cache/Proton" ]; };
}

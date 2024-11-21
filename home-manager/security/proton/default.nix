{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.proton;
in
{
  imports = [
    ./mail
    ./pass
    ./vpn
  ];

  options.dotfyls.programs.proton.enable = lib.mkEnableOption "Proton services" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { dotfyls.persist.cacheDirectories = [ ".cache/Proton" ]; };
}

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
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/Proton" = {
      mode = "0700";
      cache = true;
    };
  };
}

{ config, lib, ... }:

let
  cfg = config.dotfyls.desktops.cliphist;
in
{
  options.dotfyls.desktops.cliphist.enable = lib.mkEnableOption "cliphist";

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/cliphist" = {
      mode = "0700";
      cache = true;
    };

    services.cliphist.enable = true;
  };
}

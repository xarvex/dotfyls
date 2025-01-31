{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.plattenalbum;
in
{
  options.dotfyls.media.plattenalbum.enable = lib.mkEnableOption "Plattenalbum" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.mime-apps.media.audio = "de.wagnermartin.Plattenalbum.desktop";

    services.mpd = {
      enable = true;

      network.startWhenNeeded = true;
    };

    home.packages = with pkgs; [ plattenalbum ];
  };
}

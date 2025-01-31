{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.nomacs;
in
{
  options.dotfyls.media.nomacs.enable = lib.mkEnableOption "nomacs" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.mime-apps.media = {
      image = "org.nomacs.ImageLounge.desktop";
      vector = "org.nomacs.ImageLounge.desktop";
    };

    home.packages = with pkgs; [ nomacs-qt6 ];

    xdg.configFile."nomacs/Image Lounge.conf".source = ./${"Image Lounge.conf"};
  };
}

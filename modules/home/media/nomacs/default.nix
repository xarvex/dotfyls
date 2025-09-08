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
    home.packages = with pkgs; [ nomacs-qt6 ];

    xdg = {
      mimeApps.defaultApplications = lib.genAttrs [
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/heic"
        "image/heif"
        "image/jpeg"
        "image/jxl"
        "image/png"
        "image/tiff"
        "image/webp"
        "image/x-eps"
        "image/x-ico"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-xbitmap"
        "image/x-xpixmap"
      ] (_: "org.nomacs.ImageLounge.desktop");

      configFile."nomacs/Image Lounge.conf".source = ./${"Image Lounge.conf"};
    };
  };
}

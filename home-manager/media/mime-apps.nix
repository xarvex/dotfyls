{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mime-apps;
in
{
  options.dotfyls.media.mime-apps.enable = lib.mkEnableOption "mime-apps" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    xdg.mimeApps =
      let
        audioDefault = "mpv.desktop";
        fileDefault = "nemo.desktop";
        imageDefault = "pix.desktop";
        pdfDefault = "org.pwmt.zathura.desktop";
        textDefault = "nvim.desktop";
        videoDefault = "mpv.desktop";
        webDefault = "firefox.desktop";
      in
      {
        enable = true;

        # https://github.com/KDE/plasma-desktop/blob/master/kde-mimeapps.list
        defaultApplications = {
          # Audio
          "audio/aac" = audioDefault;
          "audio/mp4" = audioDefault;
          "audio/mpeg" = audioDefault;
          "audio/mpegurl" = audioDefault;
          "audio/ogg" = audioDefault;
          "audio/vnd.rn-realaudio" = audioDefault;
          "audio/vorbis" = audioDefault;
          "audio/x-flac" = audioDefault;
          "audio/x-mp3" = audioDefault;
          "audio/x-mpegurl" = audioDefault;
          "audio/x-ms-wma" = audioDefault;
          "audio/x-musepack" = audioDefault;
          "audio/x-oggflac" = audioDefault;
          "audio/x-pn-realaudio" = audioDefault;
          "audio/x-scpls" = audioDefault;
          "audio/x-speex" = audioDefault;
          "audio/x-vorbis" = audioDefault;
          "audio/x-vorbis+ogg" = audioDefault;
          "audio/x-wav" = audioDefault;

          # File
          "inode/directory" = fileDefault;

          # Image
          "image/avif" = imageDefault;
          "image/bmp" = imageDefault;
          "image/gif" = imageDefault;
          "image/heif" = imageDefault;
          "image/jpeg" = imageDefault;
          "image/jpg" = imageDefault;
          "image/jxl" = imageDefault;
          "image/png" = imageDefault;
          "image/svg+xml" = imageDefault;
          "image/tiff" = imageDefault;
          "image/webp" = imageDefault;
          "image/x-eps" = imageDefault;
          "image/x-icns" = imageDefault;
          "image/x-ico" = imageDefault;
          "image/x-portable-bitmap" = imageDefault;
          "image/x-portable-graymap" = imageDefault;
          "image/x-portable-pixmap" = imageDefault;
          "image/x-psd" = imageDefault;
          "image/x-tga" = imageDefault;
          "image/x-webp" = imageDefault;
          "image/x-xbitmap" = imageDefault;
          "image/x-xpixmap" = imageDefault;

          # PDF
          "application/pdf" = pdfDefault;
          "image/vnd.djvu" = pdfDefault;

          # Text
          "application/json" = textDefault;
          "application/x-docbook+xml" = textDefault;
          "application/x-ruby" = textDefault;
          "application/x-shellscript" = textDefault;
          "application/x-yaml" = textDefault;
          "inode/x-empty" = textDefault;
          "text/markdown" = textDefault;
          "text/plain" = textDefault;
          "text/rhtml" = textDefault;
          "text/x-cmake" = textDefault;
          "text/x-java" = textDefault;
          "text/x-markdown" = textDefault;
          "text/x-python" = textDefault;
          "text/x-readme" = textDefault;
          "text/x-ruby" = textDefault;
          "text/x-tex" = textDefault;

          # Video
          "application/x-matroska" = videoDefault;
          "video/3gp" = videoDefault;
          "video/3gpp" = videoDefault;
          "video/3gpp2" = videoDefault;
          "video/avi" = videoDefault;
          "video/divx" = videoDefault;
          "video/dv" = videoDefault;
          "video/fli" = videoDefault;
          "video/flv" = videoDefault;
          "video/mp2t" = videoDefault;
          "video/mp4" = videoDefault;
          "video/mp4v-es" = videoDefault;
          "video/mpeg" = videoDefault;
          "video/msvideo" = videoDefault;
          "video/ogg" = videoDefault;
          "video/quicktime" = videoDefault;
          "video/vnd.divx" = videoDefault;
          "video/vnd.mpegurl" = videoDefault;
          "video/vnd.rn-realvideo" = videoDefault;
          "video/webm" = videoDefault;
          "video/x-avi" = videoDefault;
          "video/x-flv" = videoDefault;
          "video/x-m4v" = videoDefault;
          "video/x-matroska" = videoDefault;
          "video/x-mpeg2" = videoDefault;
          "video/x-ms-asf" = videoDefault;
          "video/x-ms-wmv" = videoDefault;
          "video/x-ms-wmx" = videoDefault;
          "video/x-msvideo" = videoDefault;
          "video/x-ogm" = videoDefault;
          "video/x-ogm+ogg" = videoDefault;
          "video/x-theora" = videoDefault;
          "video/x-theora+ogg" = videoDefault;

          # Web
          "application/x-extension-htm" = webDefault;
          "application/x-extension-html" = webDefault;
          "application/x-extension-shtml" = webDefault;
          "application/x-extension-xht" = webDefault;
          "application/x-extension-xhtml" = webDefault;
          "application/xhtml+xml" = webDefault;
          "text/html" = webDefault;
          "x-scheme-handler/chrome" = webDefault;
          "x-scheme-handler/ftp" = webDefault;
          "x-scheme-handler/http" = webDefault;
          "x-scheme-handler/https" = webDefault;
        };
      };
  };
}

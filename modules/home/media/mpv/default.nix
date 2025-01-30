{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpv;
in
{
  imports = [ (self.lib.mkAliasPackageModule [ "dotfyls" "media" "mpv" ] [ "programs" "mpv" ]) ];

  options.dotfyls.media.mpv.enable = lib.mkEnableOption "mpv" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file = {
        ".local/state/mpv" = {
          mode = "0700";
          cache = true;
        };
        ".cache/mpv" = {
          mode = "0700";
          cache = true;
        };
      };

      mime-apps.media = {
        audio = lib.mkAfter "mpv.desktop";
        video = "mpv.desktop";
      };
    };

    programs.mpv = {
      enable = true;

      config = {
        # Program Behavior
        profile = "high-quality";

        # Watch Later
        save-position-on-quit = true;

        # Video
        vo = "gpu-next";
        hwdec = "nvdec,vulkan,auto-safe";

        # Window
        keep-open = true;
        cursor-autohide = 250;

        # Demuxer
        autocreate-playlist = "same";

        # Screenshot
        screenshot-format = "png";
        screenshot-dir = "${config.xdg.userDirs.pictures}/Screenshots";
        screenshot-png-compression = 9;
        screenshot-webp-lossless = true;
        screenshot-webp-compression = 6;

        # GPU Renderer Options
        gpu-api = "vulkan,auto";
      };
    };
  };
}

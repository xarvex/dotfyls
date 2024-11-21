{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.mpv;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "mpv"
      ]
      [
        "programs"
        "mpv"
      ]
    )
  ];

  options.dotfyls.programs.mpv.enable = lib.mkEnableOption "mpv" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [
      ".local/state/mpv"
      ".cache/mpv"
    ];

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

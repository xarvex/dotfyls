{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpv;
in
{
  imports = [
    ./osc.nix
    ./profiles.nix
    ./skip.nix
    ./tracks.nix
  ];

  options.dotfyls.media.mpv = {
    enable = lib.mkEnableOption "mpv" // {
      default = config.dotfyls.desktops.enable;
    };

    dynamicCropping = lib.mkEnableOption "dynamic-crop.lua";
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".local/state/mpv" = {
        mode = "0700";
        cache = true;
      };
      ".cache/mpv" = {
        mode = "0700";
        cache = true;
      };
    };

    programs.mpv = {
      enable = true;

      defaultProfiles = [ "high-quality" ];
      config = {
        # Video
        vo = "gpu-next";
        hwdec = lib.pipe (lib.optional config.dotfyls.graphics.nvidia.enable "nvdec" ++ [ "auto" ]) (
          lib.optional cfg.dynamicCropping (map (api: "${api}-copy")) ++ [ (builtins.concatStringsSep ",") ]
        );

        # Window
        keep-open = true;
        cursor-autohide = 250;

        # Screenshot
        screenshot-format = "webp";
        screenshot-dir = "${config.xdg.userDirs.pictures}/Screenshots";
        screenshot-png-compression = 9;
        screenshot-webp-lossless = true;
        screenshot-webp-compression = 6;

        # GPU Renderer Options
        gpu-api = "auto";
      };
      scripts =
        with pkgs.mpvScripts;
        lib.optional cfg.dynamicCropping dynamic-crop
        ++ lib.optional config.services.playerctld.enable mpris;
    };
  };
}

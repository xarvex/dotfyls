{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.files.nemo;

  nemo =
    with pkgs;
    (symlinkJoin {
      inherit (nemo-with-extensions) name meta;

      paths = [
        nemo-with-extensions
        nemo-fileroller

        webp-pixbuf-loader
      ];
    });
in
{
  options.dotfyls.files.nemo.enable = lib.mkEnableOption "Nemo" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      files = {
        file-roller.enable = lib.mkDefault true;
        gvfs.enable = true;
      };

      file.".cache/thumbnails" = {
        mode = "0700";
        cache = true;
      };
    };

    home.packages = [ nemo ];

    dconf.settings."org/nemo/preferences" = {
      click-double-parent-folder = true;
      close-device-view-on-device-eject = true;
      quick-renames-with-pause-in-between = true;
      show-advanced-permissions = true;
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 (1024 * 1024 * 1024);
    };

    wayland.windowManager.hyprland.settings = {
      bind = [ "SUPER, E, exec, ${lib.getExe nemo}" ];
      windowrule = [ "tag +dialog, class:nemo, title:.+ Properties" ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.libreoffice;
in
{
  options.dotfyls.media.libreoffice.enable = lib.mkEnableOption "LibreOffice" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/libreoffice".cache = true;

    home.packages = with pkgs; [
      (symlinkJoin {
        inherit (libreoffice) name meta;

        paths = [
          libreoffice
          hunspellDicts.en_US
          hunspellDicts.sv_SE

          corefonts
          vista-fonts
        ];
      })
    ];

    xdg.mimeApps.associations.removed."application/pdf" = "draw.desktop";

    wayland.windowManager.hyprland.settings.windowrule = [
      "center, class:soffice, floating:1"
      "tag +dialog, class:soffice, floating:1"

      "tag +important-prompt, class:soffice, title:Rename.*"

      "tag +picker, class:soffice, title:Save"

      "noscreenshare, class:soffice, title:Save"
    ];
  };
}

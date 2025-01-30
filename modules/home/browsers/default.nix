{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.browsers;

  desktopFiles = {
    chromium = "chromium-browser.desktop";
    firefox = "firefox.desktop";
  };
  defaultDesktopFile = desktopFiles.${cfg.default};
  otherDesktopFiles = lib.mapAttrsToList (name: _: desktopFiles.${name}) (
    lib.filterAttrs (name: browser: browser.enable && name != cfg.default) cfg.browsers
  );
in
{
  imports = [
    ./chromium
    ./firefox

    (self.lib.mkSelectorModule [ "dotfyls" "browsers" ] {
      name = "default";
      default = "firefox";
      example = "chromium";
      description = "Default browser to use.";
    })
  ];

  options.dotfyls.browsers.enable = lib.mkEnableOption "browsers" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.mime-apps.web = lib.mkMerge [
      {
        email = defaultDesktopFile;
        webpage = defaultDesktopFile;
      }
      {
        email = lib.mkAfter otherDesktopFiles;
        webpage = lib.mkAfter otherDesktopFiles;
      }
    ];
  };
}

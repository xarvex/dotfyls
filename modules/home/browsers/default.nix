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
in
{
  imports = [
    ./firefox

    ./chromium.nix
  ];

  options.dotfyls.browsers = {
    enable = lib.mkEnableOption "browsers" // {
      default = config.dotfyls.desktops.enable;
    };
    default = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "chromium"
      ];
      default = "firefox";
      example = "chromium";
      description = "Default browser to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.browsers = self.lib.enableSelected cfg.default [
      "chromium"
      "firefox"
    ];

    xdg.mimeApps.defaultApplications =
      (lib.genAttrs [
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "text/html"
        "text/htmlh"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: desktopFiles.${cfg.default}))
      // {
        "x-scheme-handler/mailto" = lib.mkAfter desktopFiles.${cfg.default};
      };
  };
}

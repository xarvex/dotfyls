{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.chromium;
in
{
  options.dotfyls.browsers.browsers.chromium.enable = lib.mkEnableOption "Chromium";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".config/chromium" = {
        mode = "0700";
        cache = true;
      };
      ".cache/chromium" = {
        mode = "0700";
        cache = true;
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };

    xdg.mimeApps.associations.removed = lib.genAttrs [
      "application/pdf"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
    ] (_: "chromium-browser.desktop");
  };
}

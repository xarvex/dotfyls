{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.chromium;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "browsers" "browsers" "chromium" ]
      [ "programs" "chromium" ]
    )
  ];

  options.dotfyls.browsers.browsers.chromium.enable = lib.mkEnableOption "Chromium";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      browsers.browsers.chromium.package = lib.mkDefault pkgs.ungoogled-chromium;

      file = {
        ".config/chromium" = {
          mode = "0700";
          cache = true;
        };
        ".cache/chromium" = {
          mode = "0700";
          cache = true;
        };
      };
    };

    programs.chromium.enable = true;
  };
}

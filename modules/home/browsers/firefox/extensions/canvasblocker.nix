{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions.settings."CanvasBlocker@kkapsner.de".settings =
    {
      # General
      blockMode = "fake";

      # Misc
      theme = "dark";
    };
}

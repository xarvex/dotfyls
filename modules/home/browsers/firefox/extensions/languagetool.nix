{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions.settings."languagetool-webextension@languagetool.org".settings =
    {
      isDarkModeEnabled = true;

      ## General settings
      hasSynonymsEnabled = true;

      ## Language options
      preferredLanguages = [
        "en"
        "sv"
      ];
      forcePreferredLanguages = true;
    };
}

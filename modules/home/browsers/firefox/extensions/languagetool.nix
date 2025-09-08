{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions.settings."languagetool-webextension@languagetool.org".settings =
    {
      isDarkModeEnabled = true;
      acceptedTermsOfServiceVersion = "2024-11-19";
      hasSeenOnboarding = true;

      ## General settings
      hasPickyModeEnabledGlobally = true;
      hasSynonymsEnabled = true;

      ## Language options
      preferredLanguages = [
        "en"
        "sv"
      ];
      forcePreferredLanguages = true;

      ## Advanced settings
      allowRemoteCheck = true;
    };
}

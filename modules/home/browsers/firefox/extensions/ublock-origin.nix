{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions.settings."uBlock0@raymondhill.net".settings =
    {
      selectedFilterLists = [
        "user-filters"

        ### Built-in
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"

        ### Ads
        "easylist"

        ### Privacy
        "easyprivacy"

        ### Malware protection, security
        "urlhaus-1"

        ### Multipurpose
        "plowe-0"

        ### Annoyances
        "easylist-chat"
        "easylist-newsletters"
        "easylist-notifications"
        "easylist-annoyances"
        "ublock-annoyances"

        ### Regions, languages
        "JPN-1"
        "SWE-1"
      ];

      user-filters = builtins.concatStringsSep "\n" [
        "||accounts.google.com/gsi/iframe/select$subdocument"

        "quizlet.com##.LoginBottomBar"
        "quizlet.com##+js(set-local-storage-item, setPageVisitsCount, $remove$)"
      ];
    };
}

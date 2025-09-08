{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.firefox;
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

      user-filters = ''
        # Remove login with Google popups.
        ||accounts.google.com/gsi/iframe/select$subdocument

        # Remove 'AI Mode'.
        google.com##div[role="listitem"]:has(a:matches-attr("href"="/\/search\?q=.+&udm=50/"))

        # Remove paywall and login requirements.
        quizlet.com##.LoginBottomBar
        quizlet.com##.paywalled-section .hideBelow--s
        quizlet.com##.paywalled-section .hideAbove--s
        quizlet.com##.ExplanationSolutionsContainer:style(max-height: unset !important;)
        quizlet.com##.ExplanationsSolutionCard div:style(filter: unset !important; -webkit-user-select: unset !important; user-select: unset !important;)
        quizlet.com##[data-testid="PayWallOverlay"]
        quizlet.com##+js(set-local-storage-item, setPageVisitsCount, $remove$)

        # Fix YouTube showing frosted glass on top of elements.
        www.youtube.com###frosted-glass:style(z-index: 100 !important;)
        www.youtube.com###chips-wrapper:style(z-index: 100 !important;)
      '';
    };
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;

  unfreePkgs = import inputs.nixpkgs {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  firefoxAddons = unfreePkgs.callPackage inputs.firefox-addons { };
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions =
    builtins.map
      (
        pkg:
        pkg.overrideAttrs (o: {
          name = "firefox-addon-${o.name}";
        })
      )
      (
        with firefoxAddons;
        [
          canvasblocker
          clearurls
          darkreader
          dearrow
          decentraleyes
          # dont-track-me-google # DOES NOT EXIST
          enhancer-for-youtube
          facebook-container
          # google-container # DOES NOT EXIST
          greasemonkey
          languagetool
          multi-account-containers
          privacy-badger
          proton-pass
          return-youtube-dislikes
          sponsorblock
          startpage-private-search
          temporary-containers
          # turn-off-the-lights # DOES NOT EXIST
          ublock-origin
          unpaywall
          vimium
          youtube-recommended-videos # unhook
        ]
      );

  home.file =
    lib.mapAttrs'
      (
        name: data:
        lib.nameValuePair ".mozilla/managed-storage/${name}.json" {
          source = (pkgs.formats.json { }).generate "firefox-managed-storage-${name}" {
            inherit name;
            description = "dotfyls";
            type = "storage";
            inherit data;
          };
        }
      )
      {
        "uBlock0@raymondhill.net" = {
          userSettings =
            lib.mapAttrsToList
              (name: value: [
                name
                (if builtins.isBool value then lib.boolToString value else value)
              ])
              {
                collapseBlocked = true;
                showIconBadge = true;
                contextMenuEnabled = true;
                cloudStorageEnabled = false;

                # Privacy
                prefetchingDisabled = true;
                hyperlinkAuditingDisabled = true;
                cnameUncloakEnabled = true;

                # Appearance
                uiTheme = "dark";
                colorBlindFriendly = false;
                tooltipsDisabled = false;
              };
          toOverwrite = {
            filters = [
              "||accounts.google.com/gsi/iframe/select$subdocument"

              "quizlet.com##.LoginBottomBar"
              "quizlet.com##+js(set-local-storage-item, setPageVisitsCount, $remove$)"
            ];
            filterLists = [
              "user-filters"

              # Built-in
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"

              # Ads
              "easylist"

              # Privacy
              "easyprivacy"

              # Malware protection, security
              "urlhaus-1"

              # Multipurpose
              "plowe-0"

              # Annoyances
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "easylist-annoyances"
              "ublock-annoyances"

              # Regions, languages
              "JPN-1"
              "SWE-1"
            ];
          };
        };
      };
}

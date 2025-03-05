{
  config,
  inputs,
  lib,
  pkgs,
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
{
  imports = [
    ./canvasblocker.nix
    ./decentraleyes.nix
    ./languagetool.nix
    ./privacy-badger.nix
    ./ublock-origin.nix
  ];

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.firefox.profiles.${config.home.username}.extensions = {
      force = true;
      packages =
        map
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
    };
  };
}

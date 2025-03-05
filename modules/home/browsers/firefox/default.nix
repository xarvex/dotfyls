{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
{
  imports = [
    ./extensions

    ./containers.nix
    ./search.nix
  ];

  options.dotfyls.browsers.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file = {
        ".mozilla".mode = "0700";
        ".mozilla/firefox" = {
          mode = "0700";
          cache = true;
        };

        ".cache/mozilla".mode = "0700";
        ".cache/mozilla/firefox" = {
          mode = "0700";
          cache = true;
        };
      };

      mime-apps.extraAssociations."application/vnd.mozilla.xul+xml" = "firefox.desktop";
    };

    programs.firefox = {
      enable = true;

      languagePacks = [
        "en-US"
        "sv-SE"
      ];
      profiles.${config.home.username}.extraConfig = ''
        ${builtins.readFile "${pkgs.arkenfox-userjs}/user.js"}

        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}

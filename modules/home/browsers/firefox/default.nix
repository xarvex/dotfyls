{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.firefox;
in
{
  imports = [
    ./extensions

    ./containers.nix
    ./search.nix
  ];

  options.dotfyls.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
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

    xdg.mimeApps.associations.added."x-scheme-handler/webcal" = "firefox.desktop";

    wayland.windowManager.hyprland.settings = {
      bind = [ "SUPER, W, exec, ${self.lib.getCfgExe config.programs.firefox}" ];
      windowrule = [
        "tag +dialog, class:firefox, title:About Mozilla Firefox"

        "tag +picker, class:firefox, title:Library"

        "noscreenshare, class:firefox, title:Library"

        "tag +popout, class:firefox, title:Picture-in-Picture"

        "keepaspectratio, class:firefox, title:Picture-in-Picture"
        "noscreenshare, class:firefox, title:Picture-in-Picture"
      ];
    };
  };
}

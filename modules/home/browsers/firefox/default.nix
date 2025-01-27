{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
{
  imports = [
    ./containers.nix
    ./extensions.nix
    ./search.nix

    (self.lib.mkAliasPackageModule
      [ "dotfyls" "browsers" "browsers" "firefox" ]
      [ "programs" "firefox" ]
    )
  ];

  options.dotfyls.browsers.browsers.firefox.enable = lib.mkEnableOption "Firefox";

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

      profiles.${config.home.username}.extraConfig = ''
        ${builtins.readFile "${pkgs.arkenfox-userjs}/user.js"}

        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}

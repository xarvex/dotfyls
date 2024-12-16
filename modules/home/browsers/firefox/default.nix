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
      [
        "dotfyls"
        "browsers"
        "browsers"
        "firefox"
      ]
      [
        "programs"
        "firefox"
      ]
    )
  ];

  options.dotfyls.browsers.browsers.firefox.enable = lib.mkEnableOption "Firefox" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".mozilla" = {
        mode = "0700";
        persist = true;
      };
      ".cache/mozilla" = {
        mode = "0700";
        persist = true;
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

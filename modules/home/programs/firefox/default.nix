{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.firefox;
in
{
  imports = [
    ./containers.nix
    ./search.nix

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "firefox"
      ]
      [
        "programs"
        "firefox"
      ]
    )
  ];

  options.dotfyls.programs.firefox.enable = lib.mkEnableOption "Firefox" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
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

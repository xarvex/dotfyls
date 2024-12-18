{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.vesktop;
in
{
  options.dotfyls.programs.vesktop = {
    enable = lib.mkEnableOption "Vesktop" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Vesktop" { default = "vesktop"; } // {
      default = pkgs.vesktop.override { withSystemVencord = true; };
      defaultText = "pkgs.vesktop.override { withSystemVencord = true; }";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".config/vesktop/sessionData" = {
      mode = "0700";
      cache = true;
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile = {
      "vesktop/settings.json".source = ./settings.json;
      "vesktop/settings/quickCss.css".source = ./settings/quickCss.css;
      "vesktop/settings/settings.json".source = ./settings/settings.json;
    };
  };
}

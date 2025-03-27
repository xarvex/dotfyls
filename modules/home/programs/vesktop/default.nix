{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.vesktop;
in
{
  options.dotfyls.programs.vesktop.enable = lib.mkEnableOption "Vesktop" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".config/vesktop/sessionData" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ (vesktop.override { withSystemVencord = true; }) ];

    xdg.configFile = {
      "vesktop/settings.json".source = ./settings.json;
      "vesktop/settings/settings.json".source = ./settings/settings.json;
    };
  };
}

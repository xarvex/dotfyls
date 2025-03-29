{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.r2modman;
in
{
  options.dotfyls.games.r2modman.enable = lib.mkEnableOption "r2modman" // {
    default = cfg'.steam.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".config/r2modman" = {
        mode = "0700";
        cache = true;
      };
      ".config/r2modmanPlus-local".cache = true;
    };

    home.packages = with pkgs; [ r2modman ];
  };
}

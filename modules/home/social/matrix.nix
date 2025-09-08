{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.social;
  cfg = cfg'.matrix;
in
{
  options.dotfyls.social.matrix.enable = lib.mkEnableOption "Element client for Matrix" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/Element" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ element-desktop ];
  };
}

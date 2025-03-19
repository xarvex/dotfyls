{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.files.tagstudio;
in
{
  options.dotfyls.files.tagstudio.enable = lib.mkEnableOption "TagStudio" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".config/TagStudio".cache = true;

    home.packages = with inputs.tagstudio.packages.${pkgs.system}; [ tagstudio-jxl ];
  };
}

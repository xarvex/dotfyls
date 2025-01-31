{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.tldr;
in
{
  options.dotfyls.shells.programs.tldr.enable = lib.mkEnableOption "tldr" // {
    default = cfg'.enableUseful;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/tlrc".cache = true;

    home.packages = with pkgs; [ tlrc ];
  };
}

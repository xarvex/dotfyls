{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.typst;
in
{
  options.dotfyls.development.languages.typst.enable = lib.mkEnableOption "Typst" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { dotfyls.file.".cache/typst".cache = true; };
}

{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.lua;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/lua-language-server".cache = true;
  };
}

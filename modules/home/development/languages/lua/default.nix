{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.lua;
in
{
  options.dotfyls.development.languages.lua.enable = lib.mkEnableOption "Lua" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/lua-language-server".cache = true;
  };
}

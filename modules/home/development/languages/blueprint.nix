{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.blueprint;
in
{
  options.dotfyls.development.languages.blueprint.enable = lib.mkEnableOption "Blueprint" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [ blueprint-compiler ];
      editors.neovim.lsp.blueprint_ls = { };
    };
  };
}

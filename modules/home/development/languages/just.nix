{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.just;
in
{
  options.dotfyls.development.languages.just.enable = lib.mkEnableOption "just" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [
        just
        just-lsp
      ];
      editors.neovim.lsp.just = { };
    };
  };
}

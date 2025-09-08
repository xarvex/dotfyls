{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.toml;
in
{
  options.dotfyls.development.languages.toml.enable = lib.mkEnableOption "TOML" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [ taplo ];
      editors.neovim.lsp.taplo.settings.indent_string = "    ";
    };
  };
}

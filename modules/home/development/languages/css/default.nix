# TODO: Complete checklist:
# [/] LSP
# [x] Linter
# [x] Formatter
# [ ] Debugger
# [ ] Tester
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.css;
in
{
  options.dotfyls.development.languages.css.enable = lib.mkEnableOption "CSS" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [ vscode-langservers-extracted ];
      languages.servers.cssls.init_options.provideFormatter = lib.mkIf cfg'.javascript.enable false;
    };
  };
}

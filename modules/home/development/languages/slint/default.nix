# TODO: Complete checklist:
# [/] LSP
# [ ] Linter
# [ ] Formatter
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
  cfg = cfg'.slint;
in
{
  options.dotfyls.development.languages.slint.enable = lib.mkEnableOption "Slint" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [ slint-lsp ];
      languages.servers.slint_lsp = { };
    };
  };
}

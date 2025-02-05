# TODO: Complete checklist:
# [ ] LSP
# [/] Linter
# [/] Formatter
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
  cfg = cfg'.sql;
in
{
  options.dotfyls.development.languages.sql.enable = lib.mkEnableOption "SQL" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development.tools = with pkgs; [ sqlfluff ];
  };
}

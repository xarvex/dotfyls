# TODO: Complete checklist:
# [/] LSP
# [ ] Linter
# [/] Formatter
# [ ] Debugger
# [ ] Tester
{ config, lib, ... }:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.typescript;
in
{
  options.dotfyls.development.languages.typescript.enable = lib.mkEnableOption "TypeScript" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development.languages.javascript.enable = true;
  };
}

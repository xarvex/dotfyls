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
  cfg = cfg'.zig;
in
{
  options.dotfyls.development.languages.zig.enable = lib.mkEnableOption "Zig" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) { dotfyls.development.tools = with pkgs; [ zls ]; };
}

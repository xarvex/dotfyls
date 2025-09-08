# TODO: Complete checklist:
# [x] LSP
# [x] Linter
# [/] Formatter
# [/] Debugger
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
  cfg = cfg'.c;
in
{
  options.dotfyls.development.languages.c.enable = lib.mkEnableOption "C" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [
        clang-tools
        vscode-extensions.vadimcn.vscode-lldb.adapter
      ];
      editors.neovim.lsp.clangd = { };
    };
  };
}

# TODO: Complete checklist:
# [x] LSP
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
  cfg = cfg'.lua;
in
{
  options.dotfyls.development.languages.lua.enable = lib.mkEnableOption "Lua" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [
        lua-language-server
        selene
        stylua
      ];
      editors.neovim.lsp.lua_ls.settings.Lua = {
        completion.callSnippet = "Replace";
        format.enable = false;
        hint = {
          enable = true;
          paramName = "Literal";
        };
      };

      file.".cache/lua-language-server".cache = true;
    };
  };
}

# TODO: Complete checklist:
# [/] LSP
# [ ] Linter
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
  cfg = cfg'.javascript;
in
{
  options.dotfyls.development.languages.javascript.enable = lib.mkEnableOption "JavaScript" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [
        prettierd
        typescript-language-server
      ];

      file = {
        ".local/share/node".cache = true;
        ".local/state/node" = {
          mode = "0700";
          cache = true;
        };

        ".local/share/npm".cache = true;
        ".local/state/npm".cache = true;
        ".cache/npm".cache = true;

        ".local/state/pnpm".cache = true;
        ".cache/pnpm".cache = true;

        ".cache/yarn".cache = true;
      };
    };

    home.sessionVariables = {
      NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    xdg.configFile."npm/npmrc".source = ./npmrc;
  };
}

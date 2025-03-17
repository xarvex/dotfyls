# TODO: Complete checklist:
# [/] LSP
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
  cfg = cfg'.javascript;

  jsonFormat = pkgs.formats.json { };
in
{
  options.dotfyls.development.languages.javascript.enable = lib.mkEnableOption "JavaScript" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development = {
        tools = with pkgs; [
          biome
          typescript-language-server
        ];
        languages.servers.biome.single_file_support = true;
      };

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

    xdg.configFile = {
      "npm/npmrc".source = ./npmrc;

      "biome/biome.json".source = jsonFormat.generate "biome-json" {
        formatter = {
          indentStyle = "space";
          indentWidth = 4;
          lineWidth = 120;
          useEditorconfig = true;
        };
        css = {
          parser.cssModules = true;
          linter.enabled = true;
        };
      };
    };
  };
}

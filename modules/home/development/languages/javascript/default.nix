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
  cfg = cfg'.javascript;

  jsonFormat = pkgs.formats.json { };
in
{
  options.dotfyls.development.languages.javascript = {
    enable = lib.mkEnableOption "JavaScript" // {
      default = cfg'.defaultEnable;
    };

    frameworks.astro = lib.mkEnableOption "Astro" // {
      default = cfg'.defaultEnable;
    };
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development = {
        tools =
          (with pkgs; [
            biome
            typescript-language-server
          ])
          ++ lib.optional cfg.frameworks.astro pkgs.astro-language-server;
        languages.servers = {
          astro = { };
          biome.workspace_required = false;
          ts_ls = {
            settings.implicitProjectConfiguration.checkJs = true;
            filetypes = [
              "javascript"
              "javascript.jsx"
              "javascriptreact"
            ];
          };
        };
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

        ".cache/typescript".cache = true;
      };
    };

    home.sessionVariables =
      {
        NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      }
      // lib.optionalAttrs cfg.frameworks.astro {
        ASTRO_TELEMETRY_DISABLED = 1;
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
        # INFO: https://biomejs.dev/internals/language-support/#html-super-languages-support
        overrides = [
          {
            include = [
              "*.astro"
              "*.svelte"
              "*.vue"
            ];
            linter.rules.style = {
              useConst = "off";
              useImportType = "off";
            };
          }
        ];
      };
    };
  };
}

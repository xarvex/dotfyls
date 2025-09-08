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
      development.tools =
        (with pkgs; [
          biome
          typescript-language-server
        ])
        ++ lib.optional cfg.frameworks.astro pkgs.astro-language-server;
      editors.neovim.lsp = {
        astro = { };
        biome = {
          settings.biome.configurationPath = "${config.xdg.configHome}/biome/biome.json";
          workspace_required = false;
        };
        ts_ls = {
          settings.implicitProjectConfiguration.checkJs = true;
          filetypes = [
            "javascript"
            "javascript.jsx"
            "javascriptreact"
          ];
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

    home.sessionVariables = {
      NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

      ASTRO_TELEMETRY_DISABLED = lib.mkIf cfg.frameworks.astro 1;

      BIOME_CONFIG_PATH = "${config.xdg.configHome}/biome";
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
        # https://biomejs.dev/internals/language-support/#html-super-languages-support
        overrides = [
          {
            includes = [
              "**/*.astro"
              "**/*.svelte"
              "**/*.vue"
            ];
            linter.rules = {
              style = {
                useConst = "off";
                useImportType = "off";
              };
              correctness = {
                noUnusedVariables = "off";
                noUnusedImports = "off";
              };
            };
          }
        ];
      };
    };
  };
}

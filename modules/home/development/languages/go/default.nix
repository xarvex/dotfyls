# TODO: Complete checklist:
# [/] LSP
# [/] Linter
# [/] Formatter
# [/] Debugger
# [/] Tester
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.go;
in
{
  options.dotfyls.development.languages.go.enable = lib.mkEnableOption "Go" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development = {
        tools = with pkgs; [
          delve
          go
          gofumpt
          gopls
          revive
        ];
        languages.servers.gopls.settings.gopls = {
          directoryFilters = map (dir: "-${dir}") cfg''.ignoreDirs;
          gofumpt = true;
          codelenses.run_govulncheck = true;
          semanticTokens = true;
          usePlaceholders = true;
          analyses.shadow = true;
          staticcheck = true;
          vulncheck = "Imports";
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariabletypes = true;
          };
        };
      };

      file = {
        ".local/share/go/bin".persist = true;
        ".cache/go/build".cache = true;
        ".cache/go/mod".cache = true;
      };
    };

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
      GOCACHE = "${config.xdg.cacheHome}/go/build";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    };

    xdg.configFile."go/telemetry/mode".source = ./telemetry/mode;
  };
}

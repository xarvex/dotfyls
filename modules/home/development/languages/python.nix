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
  cfg = cfg'.python;
in
{
  options.dotfyls.development.languages.python.enable = lib.mkEnableOption "Python" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [
        bandit
        basedpyright
        ruff
      ];
      editors.neovim.lsp = {
        basedpyright.settings.basedpyright.disableOrganizeImports = true;
        ruff.init_options.settings = {
          configuration.extend-exclude = cfg''.ignoreDirs;
          configurationPreference = "filesystemFirst";
        };
      };

      file = {
        ".local/state/python" = {
          mode = "0700";
          cache = true;
        };
        ".cache/python".cache = true;

        ".cache/python-entrypoints".cache = true;
        ".cache/pip".cache = true;
        ".local/share/virtualenv".cache = true;

        ".cache/pypoetry".cache = true;

        ".cache/uv".cache = true;

        ".cache/mypy".cache = true;
        ".cache/ruff".cache = true;
      };
    };

    home.sessionVariables = {
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";

      MYPY_CACHE_DIR = "${config.xdg.cacheHome}/mypy";
      RUFF_CACHE_DIR = "${config.xdg.cacheHome}/ruff";
    };
  };
}

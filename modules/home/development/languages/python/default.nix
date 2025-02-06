# TODO: Complete checklist:
# [x] LSP
# [/] Linter
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
      development = {
        tools = with pkgs; [
          bandit
          basedpyright
          ruff
        ];
        languages.servers.basedpyright.settings.basedpyright = { };
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
      };
    };

    home.sessionVariables = {
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history"; # 3.13
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    };
  };
}

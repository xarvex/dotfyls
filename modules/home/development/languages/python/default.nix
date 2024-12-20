{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.python;
in
{
  options.dotfyls.development.languages.python.enable = lib.mkEnableOption "Python" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".local/state/python" = {
        mode = "0700";
        cache = true;
      };
      ".cache/python".cache = true;
      ".cache/pip".cache = true;
      ".local/share/virtualenv".cache = true;

      ".cache/pypoetry".cache = true;

      ".cache/uv".cache = true;
    };

    home.sessionVariables = {
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history"; # 3.13
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    };
  };
}

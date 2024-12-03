{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.javascript;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
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

    home.sessionVariables = {
      NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    xdg.configFile."npm/npmrc".text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';
  };
}

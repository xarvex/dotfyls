{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.javascript;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [
      ".local/share/node"
      ".local/state/node"
      ".local/share/npm"
      ".local/state/npm"
      ".cache/npm"
      ".cache/pnpm"
      ".cache/yarn"
    ];

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

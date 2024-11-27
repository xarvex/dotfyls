{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.shells.bash;
in
{
  config = lib.mkIf cfg.enable {
    dotfyls.persist = {
      directories = [ ".local/state/bash" ];
      cacheDirectories = [ ".cache/blesh" ];
    };

    programs.bash = {
      enable = true;

      inherit (cfg') historySize;
      historyFileSize = config.programs.bash.historySize;
      historyFile = "${config.xdg.stateHome}/bash/history";

      # blesh parts from: https://github.com/nix-community/home-manager/pull/3238
      bashrcExtra = ''
        [[ $- == *i* ]] && source '${pkgs.blesh}/share/blesh/ble.sh' --attach=none
      '';
      initExtra = lib.mkBefore ''
        ${cfg'.greet}

        [[ ''${BLE_VERSION-} ]] && ble-attach

        bleopt prompt_ps1_final="\e[1;32m❯\e[0m "
      '';
    };
  };
}

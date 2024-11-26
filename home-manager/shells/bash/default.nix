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
  options.dotfyls.shells.shells.bash.enable = lib.mkEnableOption "Bash" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist = {
      directories = [ ".local/state/bash" ];
      cacheDirectories = [ ".cache/blesh" ];
    };

    programs.bash = {
      inherit (cfg') historySize;

      enable = true;

      historyFileSize = config.programs.bash.historySize;
      historyFile = "${config.xdg.stateHome}/bash/history";

      # blesh parts from: https://github.com/nix-community/home-manager/pull/3238
      bashrcExtra = ''
        [[ $- == *i* ]] && source '${pkgs.blesh}/share/blesh/ble.sh' --attach=none
      '';
      initExtra = lib.mkBefore ''
        ${cfg'.finalInitBins}

        [[ ''${BLE_VERSION-} ]] && ble-attach

        if command -v starship >/dev/null; then
          bleopt prompt_ps1_final="$(starship module character)"
        fi
      '';
    };
  };
}

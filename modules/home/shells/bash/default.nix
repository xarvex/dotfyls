{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.bash;
in
{
  options.dotfyls.shells.bash = {
    enable = lib.mkEnableOption "Bash" // {
      default = true;
    };
    blesh.enable = lib.mkEnableOption "ble.sh" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/state/bash" = {
        mode = "0700";
        persist = true;
      };
      ".cache/blesh" = {
        mode = "0700";
        cache = true;
      };
    };

    programs.bash = {
      enable = true;

      inherit (cfg') historySize;
      historyFileSize = config.programs.bash.historySize;
      historyFile = "${config.xdg.stateHome}/bash/history";

      # blesh parts from: https://github.com/nix-community/home-manager/pull/3238
      bashrcExtra = lib.mkIf cfg.blesh.enable ''
        [[ $- == *i* ]] && source '${pkgs.blesh}/share/blesh/ble.sh' --attach=none
      '';
      initExtra = lib.mkBefore (
        cfg'.greet
        + lib.optionalString (cfg'.greet != "") "\n"
        + lib.optionalString cfg.blesh.enable ''
          [[ ''${BLE_VERSION-} ]] && ble-attach

          bleopt prompt_ps1_final="\e[1;32m❯\e[0m "
        ''
      );
    };
  };
}

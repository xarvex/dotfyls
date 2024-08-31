{ config, lib, ... }:

let
  cfg = config.dotfyls.shells.shells.bash;
in
{
  options.dotfyls.shells.shells.bash.enable = lib.mkEnableOption "Bash" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/state/bash" ];

    programs.bash = {
      inherit (config.dotfyls.shells) historySize;

      enable = true;

      historyFileSize = config.dotfyls.shells.historySize;
      historyFile = "${config.xdg.stateHome}/bash/history";

      initExtra = lib.mkBefore config.dotfyls.shells.finalInitBins;
    };
  };
}

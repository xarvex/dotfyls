{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.shells.bash;
in
{
  options.dotfyls.shells.shells.bash.enable = lib.mkEnableOption "Bash" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/state/bash" ];

    programs.bash = {
      inherit (cfg') historySize;

      enable = true;

      historyFileSize = config.programs.bash.historySize;
      historyFile = "${config.xdg.stateHome}/bash/history";

      initExtra = lib.mkBefore cfg'.finalInitBins;
    };
  };
}

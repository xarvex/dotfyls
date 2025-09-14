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

    blesh = {
      enable = lib.mkEnableOption "ble.sh" // {
        default = true;
      };

      initExtra = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Lines to be inserted into blesh's configuration.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.file.".local/state/bash" = {
          mode = "0700";
          persist = true;
        };

        programs.bash = {
          enable = true;

          inherit (cfg') historySize;
          historyFileSize = config.programs.bash.historySize;
          historyFile = "${config.xdg.stateHome}/bash/history";

          initExtra = lib.mkBefore (lib.optionalString (cfg'.greet != "") "${cfg'.greet}\n");
        };
      }

      (lib.mkIf cfg.blesh.enable {
        dotfyls.file.".cache/blesh" = {
          mode = "0700";
          cache = true;
        };

        # From: https://github.com/nix-community/home-manager/pull/3238
        programs.bash = {
          bashrcExtra =
            # bash
            ''
              [[ "''${-}" == *i* ]] && source '${pkgs.blesh}/share/blesh/ble.sh' --attach=none
            '';
          initExtra =
            lib.mkAfter
              # bash
              ''
                [[ "''${BLE_VERSION-}" ]] && ble-attach
              '';
        };

        xdg.configFile."blesh/init.sh".text = lib.mkIf (cfg.blesh.initExtra != "") cfg.blesh.initExtra;
      })
    ]
  );
}

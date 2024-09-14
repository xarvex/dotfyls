{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.solaar;
in
{
  options.dotfyls.programs.solaar = {
    enable = lib.mkEnableOption "Solaar";
    deviceConfig = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Solaar device config, note that this may need to be refreshed periodically.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile =
      {
        "solaar/rules.yaml".text =
          ''
            %YAML 1.3
            ---
            - Key: [Lock PC, pressed]
          ''
          + lib.optionalString config.dotfyls.desktops.locks.enable ''
            - Execute: [${lib.getExe config.dotfyls.desktops.locks.command}]
          ''
          + ''
            ...
            ---
            - Key: [Mute Microphone, pressed]
            - KeyPress:
              - XF86_AudioMicMute
              - click
            ...
            ---
            - Key: [Snipping Tool, pressed]
            - KeyPress:
              - Print
              - click
            ...
          '';
      }
      // lib.optionalAttrs (cfg.deviceConfig != null) { "solaar/config.yaml".source = cfg.deviceConfig; };
  };
}

{ config, lib, ... }:

let
  cfg' = config.dotfyls.input;
  cfg = cfg'.solaar;
in
{
  options.dotfyls.input.solaar = {
    enable = lib.mkEnableOption "Solaar";
    deviceConfig = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Solaar device config, note that this may need to be refreshed periodically.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    xdg.configFile =
      {
        "solaar/rules.yaml".source = ./rules.yaml;
      }
      // lib.optionalAttrs (cfg.deviceConfig != null) { "solaar/config.yaml".source = cfg.deviceConfig; };
  };
}

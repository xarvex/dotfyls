{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.security.wireshark;
in
{
  options.dotfyls.security.wireshark = {
    enable =
      lib.mkEnableOption "Wireshark"
      // lib.optionalAttrs (osConfig != null) {
        default = osConfig.dotfyls.security.wireshark.enable;
      };
    application =
      lib.mkEnableOption "Wireshark application"
      // lib.optionalAttrs (osConfig != null) {
        default = osConfig.dotfyls.security.wireshark.application;
      };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.mime-apps.security.network-capture = "org.wireshark.Wireshark.desktop";
  };
}

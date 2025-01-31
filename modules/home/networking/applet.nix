{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.applet;
in
{
  options.dotfyls.networking.applet.enable = lib.mkEnableOption "NetworkManager applet" // {
    default =
      config.dotfyls.desktops.enable && (osConfig == null || osConfig.dotfyls.networking.manager.enable);
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    # Package also provides nm-connection-editor.
    home.packages = with pkgs; [ networkmanagerapplet ];

    services.network-manager-applet.enable = true;
  };
}

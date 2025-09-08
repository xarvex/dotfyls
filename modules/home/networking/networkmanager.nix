{
  config,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.networkmanager;
  osCfg = if osConfig == null then null else osConfig.dotfyls.networking.networkmanager;
in
{
  options.dotfyls.networking.networkmanager = {
    enable = lib.mkEnableOption "NetworkManager" // {
      default = osCfg == null || osCfg.enable;
    };
    enableApplet = lib.mkEnableOption "NetworkManager applet" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
    lib.mkMerge [
      {
        wayland.windowManager.hyprland.settings.bindl = [
          ", XF86WLAN, exec, ${lib.getExe self.packages.${pkgs.system}.dotfyls-nm-radio-toggle}"
        ];
      }

      (lib.mkIf cfg.enableApplet {
        # Package also provides nm-connection-editor.
        home.packages = with pkgs; [ networkmanagerapplet ];

        services.network-manager-applet.enable = true;
      })
    ]
  );
}

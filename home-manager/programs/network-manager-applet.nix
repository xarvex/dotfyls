{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.network-manager-applet;
in
{
  options.dotfyls.programs.network-manager-applet.enable =
    lib.mkEnableOption "NetworkManager Applet"
    // {
      default = config.dotfyls.desktops.enable;
    };

  config = lib.mkIf cfg.enable {
    services.network-manager-applet.enable = true;
  };
}

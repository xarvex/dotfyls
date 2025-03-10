{
  config,
  lib,
  self,
  user,
  ...
}:

let
  cfg = config.dotfyls.programs.openrgb;
  hmCfg = config.hm.dotfyls.programs.openrgb;
in
{
  options.dotfyls.programs.openrgb = {
    enable = lib.mkEnableOption "OpenRGB" // {
      default = hmCfg.enable;
    };
    sizes = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "OpenRGB sizes file for devices.";
    };
    bootProfile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "OpenRGB profile to start on boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Confirm permissions.
    dotfyls.file."/var/lib/OpenRGB".persist = true;

    services.hardware.openrgb.enable = true;

    systemd = {
      services.openrgb.serviceConfig.ExecStart = lib.mkForce ''
        ${self.lib.getCfgExe config.services.hardware.openrgb} --server \
          --server-port ${toString config.services.hardware.openrgb.server.port} \
          --profile ${cfg.bootProfile}
      '';

      tmpfiles.rules = [
        "d /var/lib/OpenRGB 0755 root root - -"
        "L+ /var/lib/OpenRGB/sizes.ors - - - - ${cfg.sizes}"
      ];
    };

    users.groups.i2c.members = [ user ];
  };
}

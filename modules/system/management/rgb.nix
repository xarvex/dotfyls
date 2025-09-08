{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.management.rgb;
in
{
  options.dotfyls.management.rgb = {
    enable = lib.mkEnableOption "OpenRGB";
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

      tmpfiles.settings.dotfyls-management-rgb = {
        "/var/lib/OpenRGB".d = {
          mode = "0755";
          owner = "root";
          group = "root";
        };
        "/var/lib/OpenRGB/sizes.ors"."L+".argument = cfg.sizes;
      };
    };

    users.groups.i2c.members = [ config.dotfyls.meta.user ];
  };
}

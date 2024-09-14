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
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "openrgb"
      ]
      [
        "services"
        "hardware"
        "openrgb"
      ]
    )
  ];

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
    dotfyls.persist.directories = [ "/var/lib/OpenRGB" ];

    services.hardware.openrgb.enable = true;

    systemd = {
      services.openrgb.serviceConfig.ExecStart = lib.mkForce ''
        ${self.lib.getCfgExe cfg} --server \
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

{ config, lib, pkgs, self, user, ... }:

let
  cfg = config.dotfyls.programs.openrgb;
  hmCfg = config.hm.dotfyls.programs.openrgb;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "openrgb" ]
      [ "services" "hardware" "openrgb" ])
  ];

  options.dotfyls.programs.openrgb = {
    enable = lib.mkEnableOption "OpenRGB" // { default = hmCfg.enable; };
    bootProfile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "OpenRGB profile to start on boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ "/var/lib/OpenRGB" ];

    services.hardware.openrgb = {
      enable = true;
      package = lib.mkDefault pkgs.openrgb-with-all-plugins;
    };

    systemd.services.openrgb.serviceConfig.ExecStart = lib.mkForce ''
      ${lib.getExe cfg.package} --server \
        --server-port ${toString config.services.hardware.openrgb.server.port} \
        --profile ${cfg.bootProfile}
    '';

    boot.kernelModules = [ "i2c-dev" ];

    users.groups.i2c.members = [ user ];
  };
}

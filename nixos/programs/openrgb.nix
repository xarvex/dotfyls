{ config, lib, pkgs, user, ... }:

let
  cfg = config.dotfyls.programs.openrgb;
  hmCfg = config.hm.dotfyls.programs.openrgb;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "programs" "openrgb" "package" ]
      [ "services" "hardware" "openrgb" "package" ])
  ];

  options.dotfyls.programs.openrgb.enable = lib.mkEnableOption "OpenRGB"
    // { default = hmCfg.enable; };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ "/var/lib/OpenRGB" ];

    services.hardware.openrgb = {
      enable = true;
      package = lib.mkDefault pkgs.openrgb-with-all-plugins;
    };

    boot.kernelModules = [ "i2c-dev" ];

    users.groups.i2c.members = [ user ];
  };
}

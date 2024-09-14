{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.dotfyls.programs.virt-manager;
in
{
  options.dotfyls.programs.virt-manager.enable = lib.mkEnableOption "virt-manager" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ "/var/lib/libvirt" ];

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    users.users.${user}.extraGroups = [ "libvirtd" ];
  };
}

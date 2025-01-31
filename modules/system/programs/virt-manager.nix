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
    dotfyls.file = {
      "/var/lib/libvirt".cache = true;
      "/var/cache/libvirt" = {
        mode = "0711";
        cache = true;
      };
    };

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    users.groups.libvirtd.members = [ user ];
  };
}

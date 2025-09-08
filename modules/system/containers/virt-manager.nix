{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.virt-manager;
in
{
  options.dotfyls.containers.virt-manager.enable = lib.mkEnableOption "virt-manager" // {
    default = !config.dotfyls.meta.machine.isVirtual && config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      "/var/lib/libvirt".cache = true;
      "/var/cache/libvirt" = {
        mode = "0711";
        cache = true;
      };
    };

    programs.virt-manager.enable = true;

    # HACK: `libvirt` should be using hooks to do this.
    # Without this, guests will have no internet connectivity.
    # See: https://github.com/NixOS/nixpkgs/issues/263359
    networking.firewall.interfaces."virbr*" = lib.mkIf config.networking.nftables.enable {
      allowedTCPPorts = [ 53 ]; # DNS
      allowedUDPPorts = [
        53 # DNS
        67 # DHCP
      ];
    };

    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;

        runAsRoot = false;
      };
    };

    systemd.tmpfiles.settings.dotfyls-containers-virt-manager = {
      "/var/lib/libvirt/isos" = {
        "10-d" = {
          type = "d";
          mode = "0775";
          group = "libvirtd";
        };
        "20-Z" = {
          type = "Z";
          mode = "0775";
          group = "libvirtd";
        };
      };
      "/var/lib/libvirt/qemu".Z.user =
        if config.virtualisation.libvirtd.qemu.runAsRoot then "root" else "qemu-libvirtd";
    };

    users.groups.libvirtd.members = [ config.dotfyls.meta.user ];
  };
}

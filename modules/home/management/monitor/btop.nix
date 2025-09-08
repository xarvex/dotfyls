{ config, lib, ... }:

let
  cfg' = config.dotfyls.management.monitor;
  cfg = cfg'.btop;
in
{
  options.dotfyls.management.monitor.btop.enable = lib.mkEnableOption "Btop" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.btop = {
      enable = true;

      settings = {
        theme_background = false;
        vim_keys = true;
        shown_boxes = builtins.concatStringsSep " " [
          "cpu"
          "mem"
          "net"
          "proc"
          "gpu0"
        ];
        update_ms = 1000;
        cpu_single_graph = true;
        disks_filter = builtins.concatStringsSep " " (
          lib.mapAttrsToList (_: drive: drive.mountpoint) config.dotfyls.filesystems.drives
          ++ [ "/boot" ]
          ++ (
            if config.dotfyls.filesystems.impermanence.enable then
              [
                "/cache"
                "/nix"
                "/persist"
              ]
            else
              [ "/" ]
          )
        );
        swap_disk = false;
        only_physical = false;
        gpu_mirror_graph = false;
      };
    };
  };
}

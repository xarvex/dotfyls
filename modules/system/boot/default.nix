{ config, lib, ... }:

let
  cfg = config.dotfyls.boot;
in
{
  imports = [
    ./kernel

    ./console.nix
    ./loader.nix
    ./plymouth.nix
  ];

  options.dotfyls.boot.silent = lib.mkEnableOption "silent boot";

  config = lib.mkMerge [
    {
      hardware.enableRedistributableFirmware = true;

      boot.initrd.systemd.enable = true;
    }

    (lib.mkIf cfg.silent {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;

        kernelParams = [
          "boot.shell_on_fail"
          "loglevel=3"
          "quiet"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_level=3"
          "udev.log_priority=3"
        ];
      };
    })
  ];
}

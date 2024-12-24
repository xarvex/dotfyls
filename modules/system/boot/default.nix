{ config, lib, ... }:

let
  cfg = config.dotfyls.boot;
in
{
  imports = [
    ./kernel.nix
    ./plymouth.nix
  ];

  options.dotfyls.boot.silent = lib.mkEnableOption "silent boot";

  config = lib.mkMerge [
    {
      boot = {
        initrd.systemd.enable = true;
        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
            memtest86.enable = true;
          };
        };
      };

      hardware.enableRedistributableFirmware = true;
    }

    (lib.mkIf cfg.silent {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        loader.timeout = 0;

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

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.boot;
  cfg = cfg'.console;
in
{
  options.dotfyls.boot.console = {
    enable = lib.mkEnableOption "console" // {
      default = true;
    };

    efi = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            width = lib.mkOption {
              type = lib.types.int;
              example = 1920;
              description = "Width of the EFI console.";
            };
            height = lib.mkOption {
              type = lib.types.int;
              example = 1080;
              description = "Height of the EFI console.";
            };
          };
        }
      );
      default = null;
      description = "Configuration for the EFI console.";
    };
    displays = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            width = lib.mkOption {
              type = lib.types.int;
              example = 1920;
              description = "Width of the display.";
            };
            height = lib.mkOption {
              type = lib.types.int;
              example = 1080;
              description = "Height of the display.";
            };
            refresh = lib.mkOption {
              type = lib.types.int;
              default = 60;
              example = 60;
              description = "Refresh of the display.";
            };
            vertical = lib.mkEnableOption "vertical transformation for the display";
          };
        }
      );
      default = { };
      description = "Attribute set of configurations for display connectors.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams =
        # INFO: https://docs.kernel.org/fb/efifb.html
        lib.optional (cfg.efi != null) "video=efifb:${toString cfg.efi.width}x${toString cfg.efi.height}"
        # INFO: https://docs.kernel.org/fb/modedb.html
        ++ lib.optionals (cfg.displays != [ ]) (
          lib.mapAttrsToList (
            connector: display:
            "video=${connector}:${toString display.width}x${toString display.height}@${toString display.refresh}"
          ) cfg.displays
        );

      # INFO: https://discourse.nixos.org/t/how-to-show-characters-for-disk-encryption-passphrase/50181/4
      initrd.systemd = {
        extraBin.setleds = lib.getExe' pkgs.kbd "setleds";
        services.dotfyls-tty-numlock = {
          description = "dotfyls - TTY Numlock";
          wantedBy = [ "initrd.target" ];
          before = [ "systemd-udevd.service" ];
          serviceConfig.Type = "oneshot";
          unitConfig.DefaultDependencies = false;
          script = builtins.concatStringsSep "\n" (
            builtins.genList (tty: "/bin/setleds -D +num </dev/tty${toString (tty + 1)}") 6
          );
        };
      };
    };

    console = {
      earlySetup = true;

      # INFO: https://github.com/rose-pine/linux-tty
      colors = [
        "191724"
        "eb6f92"
        "9ccfd8"
        "f6c177"
        "31748f"
        "c4a7e7"
        "ebbcba"
        "e0def4"
        "26233a"
        "eb6f92"
        "9ccfd8"
        "f6c177"
        "31748f"
        "c4a7e7"
        "ebbcba"
        "e0def4"
      ];
    };
  };
}

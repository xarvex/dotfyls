{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.management.input;
  hmCfg = config.hm.dotfyls.management.input;
in
{
  options.dotfyls.management.input = {
    numlockDefault = lib.mkEnableOption "numlock by default" // {
      default = hmCfg.numlockDefault;
    };
    useUinput = lib.mkEnableOption "uinput" // {
      default = hmCfg.useUinput;
    };
    useInput = lib.mkEnableOption "input" // {
      default = hmCfg.useInput;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.numlockDefault {
      # https://discourse.nixos.org/t/how-to-show-characters-for-disk-encryption-passphrase/50181/4
      boot.initrd.systemd = {
        extraBin.setleds = lib.getExe' pkgs.kbd "setleds";
        services.dotfyls-tty-numlock = {
          description = "dotfyls - TTY Numlock";
          before = [ "systemd-udevd.service" ];
          unitConfig.DefaultDependencies = false;

          serviceConfig.Type = "oneshot";
          script = builtins.concatStringsSep "\n" (
            builtins.genList (tty: "/bin/setleds -D +num </dev/tty${toString (tty + 1)}") 6
          );

          wantedBy = [ "initrd.target" ];
        };
      };
    })

    (lib.mkIf cfg.useUinput {
      hardware.uinput.enable = true;

      users.groups.uinput.members = [ config.dotfyls.meta.user ];
    })

    (lib.mkIf cfg.useInput {
      users.groups.input.members = [ config.dotfyls.meta.user ];
    })
  ];
}

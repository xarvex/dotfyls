{ config, lib, ... }:

{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "idles" "idles" "swayidle" "package" ]
      [ "services" "swayidle" "package" ])
  ];

  options.dotfyls.desktops.idles.idles.swayidle.enable = lib.mkEnableOption "swayidle";

  config = lib.mkIf config.dotfyls.desktops.idles.idles.swayidle.enable (lib.mkMerge [
    { services.swayidle.enable = true; }

    (
      let cfg = config.dotfyls.desktops.idles.lock; in lib.mkIf cfg.enable {
        services.swayidle = {
          events = [{
            event = "before-sleep";
            command = lib.getExe cfg.command;
          }];

          timeouts = [{
            timeout = cfg.timeout;
            command = lib.getExe cfg.command;
          }];
        };
      }
    )

    (
      let cfg = config.dotfyls.desktops.idles.displays; in lib.mkIf cfg.enable {
        services.swayidle = {
          events = [{
            event = "after-resume";
            command = lib.getExe cfg.onCommand;
          }];

          timeouts = [{
            timeout = cfg.timeout;
            command = lib.getExe cfg.offCommand;
            resumeCommand = lib.getExe cfg.onCommand;
          }];
        };
      }
    )

    (
      let cfg = config.dotfyls.desktops.idles.suspend; in lib.mkIf cfg.enable {
        services.swayidle.timeouts = [{
          timeout = cfg.timeout;
          command = lib.getExe cfg.command;
        }];
      }
    )
  ]);
}

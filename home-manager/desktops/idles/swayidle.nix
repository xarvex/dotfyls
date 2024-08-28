{ config, lib, self, ... }:

let
  cfg' = config.dotfyls.desktops.idles;
  cfg = cfg'.idles.swayidle;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "desktops" "idles" "idles" "swayidle" ]
      [ "services" "swayidle" ])
  ];

  options.dotfyls.desktops.idles.idles.swayidle.enable = lib.mkEnableOption "swayidle";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { services.swayidle.enable = true; }

    (
      let lCfg = cfg'.lock; in lib.mkIf lCfg.enable {
        services.swayidle = {
          events = [{
            event = "before-sleep";
            command = lib.getExe lCfg.command;
          }];

          timeouts = [{
            timeout = lCfg.timeout;
            command = lib.getExe lCfg.command;
          }];
        };
      }
    )

    (
      let dCfg = cfg'.displays; in lib.mkIf dCfg.enable {
        services.swayidle = {
          events = [{
            event = "after-resume";
            command = lib.getExe dCfg.onCommand;
          }];

          timeouts = [{
            timeout = dCfg.timeout;
            command = lib.getExe dCfg.offCommand;
            resumeCommand = lib.getExe dCfg.onCommand;
          }];
        };
      }
    )

    (
      let sCfg = cfg'.suspend; in lib.mkIf sCfg.enable {
        services.swayidle.timeouts = [{
          timeout = sCfg.timeout;
          command = lib.getExe sCfg.command;
        }];
      }
    )
  ]);
}

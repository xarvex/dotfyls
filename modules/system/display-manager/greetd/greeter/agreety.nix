{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.displayManager;
  cfg' = cfg''.displayManager.greetd;
  cfg = cfg'.greeter.greeter.agreety;
in
{
  options.dotfyls.displayManager.displayManager.greetd.greeter.greeter.agreety = {
    enable = lib.mkEnableOption "agreety";
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    services.greetd.settings.default_session.command = "${self.lib.getCfgExe' cfg' "agreety"}";
  };
}

{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.display-managers;
  cfg' = cfg''.display-managers.greetd;
  cfg = cfg'.greeter.greeter.agreety;
in
{
  options.dotfyls.display-managers.display-managers.greetd.greeter.greeter.agreety = {
    enable = lib.mkEnableOption "agreety";
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    services.greetd.settings.default_session.command = "${self.lib.getCfgExe' cfg' "agreety"}";
  };
}

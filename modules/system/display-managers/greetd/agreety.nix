{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.display-managers;
  cfg' = cfg''.greetd;
  cfg = cfg'.greeter.agreety;
in
{
  options.dotfyls.display-managers.greetd.greeter.agreety.enable = lib.mkEnableOption "agreety";

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    services.greetd.settings.default_session.command =
      self.lib.getCfgExe' config.services.greetd "agreety";
  };
}

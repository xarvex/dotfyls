{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.displayManager;
  cfg = cfg'.displayManager.cage;
in
{
  options.dotfyls.displayManager.displayManager.cage = {
    enable = lib.mkEnableOption "Cage";
    startCommand = self.lib.mkCommandOption "start with Cage" // {
      default = pkgs.dotfyls.mkCommandExe ''
        ${lib.getExe pkgs.foot} -- ${lib.getExe pkgs.shadow "login"}
      '';
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.cage = {
      enable = true;

      user = "caged";
      program = lib.getExe cfg.startCommand;
    };

    users.users.caged = {
      isSystemUser = true;
      group = "caged";
    };

    users.groups.caged = { };
  };
}

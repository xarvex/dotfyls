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
      default = pkgs.dotfyls.mkCommand ''
        exec ${lib.getExe pkgs.foot} -o shell="sudo ${lib.getExe' pkgs.shadow "login"}" -o font=monospace:size=16
      '';
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.cage = {
      enable = true;

      user = "caged";
      environment.WLR_RENDERER = "pixman";
      program = lib.getExe cfg.startCommand;
    };

    security.sudo.extraRules = [
      {
        users = [ "caged" ];
        runAs = "root";
        commands = [
          {
            command = lib.getExe' pkgs.shadow "login";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    users = {
      users.caged = {
        isSystemUser = true;
        group = "caged";
      };
      groups.caged = { };
    };
  };
}

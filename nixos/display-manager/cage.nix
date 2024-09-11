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
        ${lib.getExe pkgs.foot} -- ${lib.getExe' pkgs.shadow "login"} -p
      '';
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.cage = {
      enable = true;

      user = "caged";
      environment.WLR_RENDERER_ALLOW_SOFTWARE = "1";
      program = lib.getExe cfg.startCommand;
    };

    users.users.caged = {
      isSystemUser = true;
      group = "caged";
    };

    security.sudo.extraRules = [
      {
        users = [ "caged" ];
        commands = [
          {
            command = lib.getExe' pkgs.shadow "login";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    users.groups.caged = { };
  };
}

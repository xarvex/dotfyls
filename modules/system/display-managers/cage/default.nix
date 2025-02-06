{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.display-managers;
  cfg = cfg'.display-managers.cage;
in
{
  options.dotfyls.display-managers.display-managers.cage.enable = lib.mkEnableOption "Cage";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    environment.shellInit = lib.mkBefore (builtins.readFile ./login.sh);

    programs.fish.shellInit = lib.mkBefore (builtins.readFile ./login.fish);

    services.cage = {
      enable = true;

      user = "caged";
      environment.WLR_RENDERER = "pixman";
      program = pkgs.writeScript "dotfyls-cage-login" (
        let
          foot = lib.getExe pkgs.foot;
        in
        ''
          exec ${foot} -o shell="sudo /run/current-system/sw/bin/login" -o font=monospace:size=16
        ''
      );
    };

    security.sudo.extraRules = [
      {
        users = [ "caged" ];
        runAs = "root";
        commands = [
          {
            command = "/run/current-system/sw/bin/login";
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

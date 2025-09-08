{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.display-managers;
  cfg' = cfg''.greetd;
  cfg = cfg'.greeter.tuigreet;
in
{
  options.dotfyls.display-managers.greetd.greeter.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    dotfyls.file."/var/cache/tuigreet" = {
      user = "greeter";
      cache = true;
    };

    services.greetd.settings.default_session.command = builtins.concatStringsSep " " [
      (lib.getExe pkgs.tuigreet)
      "--time"
      "--user-menu"
      "--remember"
      "--remember-user-session"
      "--theme 'text=cyan;border=magenta;prompt=green'"
      "--power-shutdown '/run/current-system/sw/bin/systemctl poweroff'"
      "--power-reboot '/run/current-system/sw/bin/systemctl reboot'"
    ];
  };
}

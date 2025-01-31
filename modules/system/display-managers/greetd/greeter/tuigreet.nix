{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.display-managers;
  cfg' = cfg''.display-managers.greetd;
  cfg = cfg'.greeter.greeter.tuigreet;
in
{
  options.dotfyls.display-managers.display-managers.greetd.greeter.greeter.tuigreet.enable =
    lib.mkEnableOption "tuigreet";

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    dotfyls.file."/var/cache/tuigreet" = {
      user = "greeter";
      cache = true;
    };

    services.greetd.settings.default_session.command = builtins.concatStringsSep " " [
      (lib.getExe pkgs.greetd.tuigreet)
      "--time"
      "--user-menu"
      "--remember"
      "--remember-user-session"
      "--theme 'text=cyan;border=magenta;prompt=green'"
      "--power-shutdown 'systemctl poweroff'"
      "--power-reboot 'systemctl reboot'"
    ];
  };
}

{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.displayManager;
  cfg' = cfg''.displayManager.greetd;
  cfg = cfg'.greeter.greeter.tuigreet;
in
{
  options.dotfyls.displayManager.displayManager.greetd.greeter.greeter.tuigreet = {
    enable = lib.mkEnableOption "tuigreet";
    package = lib.mkPackageOption pkgs [ "greetd" "tuigreet" ] { };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "text=cyan;border=magenta;prompt=green";
      example = "text=cyan;border=magenta;prompt=green";
      description = "Theme used for tuigreet.";
    };
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    dotfyls.file."/var/cache/tuigreet" = {
      user = "greeter";
      cache = true;
    };

    services.greetd.settings.default_session.command = ''
      ${self.lib.getCfgExe cfg} \
        --time \
        --user-menu \
        --remember \
        --remember-user-session \
        --theme '${cfg.theme}'
        --power-shutdown 'systemctl poweroff' \
        --power-reboot 'systemctl reboot' \
    '';
  };
}

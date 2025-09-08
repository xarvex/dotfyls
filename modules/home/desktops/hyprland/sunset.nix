{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.hyprland;
  cfg = cfg'.sunset;

  inherit (self.packages.${pkgs.system}) dotfyls-hyprsol;
in
{
  options.dotfyls.desktops.hyprland.sunset = {
    enable = lib.mkEnableOption "hyprsunset" // {
      default = config.dotfyls.meta.machine.isDesktop || config.dotfyls.meta.machine.isLaptop;
    };

    step = lib.mkOption {
      type = lib.types.int;
      default = 100;
      example = 250;
      description = "Step value to use for transitions.";
    };
    transitions = lib.mkOption {
      type = with lib.types; attrsOf int;
      default = { };
      description = "Attrset of times and the temperature values that should transition at each time.";
    };
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    dotfyls.desktops.hyprland.sunset.transitions = {
      "00:00" = 3500;
      "02:00" = 2500;
      "06:00" = 3500;
      "08:00" = 4000;
      "10:00" = 6600;
      "22:00" = 4000;
    };

    home.packages = [ dotfyls-hyprsol ];

    services.hyprsunset = {
      enable = true;

      importantPrefixes = lib.mkOptionDefault [ "time" ];
      settings.profile = lib.mapAttrsToList (time: temperature: {
        inherit time temperature;
      }) cfg.transitions;
    };

    systemd.user = lib.mkMerge (
      [
        {
          # https://github.com/hyprwm/hyprsunset/blob/main/systemd/hyprsunset.service.in
          services.hyprsunset = lib.mkForce {
            Unit = {
              Description = "An application to enable a blue-light filter on Hyprland.";
              Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset/";
              After = [ config.wayland.systemd.target ];
              Requires = [ config.wayland.systemd.target ];
              PartOf = [ config.wayland.systemd.target ];
              ConditionEnvironment = "WAYLAND_DISPLAY";
              X-Restart-Triggers = lib.mkIf (config.services.hyprsunset.settings != { }) [
                config.xdg.configFile."hypr/hyprsunset.conf".source
              ];
            };

            Service = {
              Type = "simple";
              ExecStart = "${self.lib.getCfgExe config.services.hyprsunset}${
                lib.optionalString (
                  config.services.hyprsunset.extraArgs != [ ]
                ) " ${lib.escapeShellArgs config.services.hyprsunset.extraArgs}"
              }";
              Slice = "session.slice";
              Restart = "on-failure";
            };

            Install.WantedBy = [ config.services.hyprsunset.systemdTarget ];
          };
        }
      ]
      ++ lib.mapAttrsToList (
        time: temperature:
        let
          name = "hyprsunset-${time}";
        in
        {
          services.${name} = {
            Unit = {
              Description = "hyprsunset transition service (${time})";
              After = [ "hyprsunset.service" ];
              Requires = [ "hyprsunset.service" ];
              ConditionEnvironment = "WAYLAND_DISPLAY";
            };

            Service = {
              Type = "simple";
              ExecStart = "${lib.getExe dotfyls-hyprsol} ${toString temperature} ${toString cfg.step}";
            };

            Install = { };
          };
          timers.${name} = {
            Unit.Description = "hyprsunset transition timer (${time})";

            Timer.OnCalendar = "*-*-* ${time}:00";

            Install.WantedBy = [ config.wayland.systemd.target ];
          };
        }
      ) cfg.transitions
    );
  };
}

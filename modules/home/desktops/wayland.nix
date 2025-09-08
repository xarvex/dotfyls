{
  config,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.wayland;
in
{
  options.dotfyls.desktops.wayland = {
    uwsm = {
      enable = lib.mkEnableOption "Universal Wayland Session Manager" // {
        default = osConfig != null && osConfig.programs.uwsm.enable;
      };
      prefix = lib.mkOption {
        type = lib.types.str;
        default = "apprun -oe SHELL=${config.home.sessionVariables.SHELL} -- ";
        defaultText = lib.literalExpression "apprun -oe SHELL=\${config.home.sessionVariables.SHELL} --";
        example = "uwsm-app ";
        description = "Prefix command used before launching a command.";
      };
    };
    sessionVariables = lib.mkOption {
      type = with lib.types; attrsOf (either int str);
      default = { };
      description = ''
        Environment variables that will be set for Wayland sessions.
        The variable values must be as described in {manpage}`environment.d(5)`.
      '';
    };
  };

  config = lib.mkIf cfg'.enable (
    lib.mkMerge [
      {
        dotfyls.desktops.wayland.sessionVariables = {
          EGL_BACKEND = "wayland";
          GDK_BACKEND = "wayland,x11,*";
          QT_QPA_PLATFORM = "wayland;xcb";
          SDL_VIDEODRIVER = "wayland,x11,windows";
          CLUTTER_BACKEND = "wayland";

          NIXOS_OZONE_WL = 1;
          MOZ_ENABLE_WAYLAND = 1;

          QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        };

        home.packages = with pkgs; [ wl-clipboard ];
      }

      (lib.mkIf cfg.uwsm.enable {
        home.packages = [ self.packages.${pkgs.system}.runapp ];

        xdg.configFile."uwsm/env".text = config.lib.shell.exportAll cfg.sessionVariables;
      })
    ]
  );
}

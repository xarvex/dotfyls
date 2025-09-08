{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
in
{
  imports = [
    ./appearance.nix
    ./binds.nix
    ./interaction.nix
    ./plugins.nix
    ./portal.nix
    ./rules.nix
    ./sunset.nix
  ];

  options.dotfyls.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    scrolling = lib.mkEnableOption "hyprscrolling";
    gestures = lib.mkEnableOption "Hyprgrass" // {
      default = builtins.any (display: display.touchscreen) cfg'.displays;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      desktops = {
        cliphist.enable = lib.mkDefault true;
        dotpanel.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        hypridle.enable = true;
        hyprlock.enable = true;
        rofi.enable = lib.mkDefault true;
        soteria.enable = lib.mkDefault true;
        swww.enable = lib.mkDefault true;
      };

      # TODO: Confirm permissions.
      file.".cache/hyprland".cache = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = !cfg'.wayland.uwsm.enable;
        enableXdgAutostart = true;

        variables = [ "--all" ];
      };

      importantPrefixes = lib.mkOptionDefault [ "output" ];
      settings = {
        xwayland.force_zero_scaling = true;

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
          enforce_permissions = true;
        };

        misc.anr_missed_pings = 3;

        monitorv2 = map (display: {
          output =
            if display.connector == null then "desc:${display.make} ${display.model}" else display.connector;
          mode = "${toString display.width}x${toString display.height}@${toString display.refresh}";
          inherit (display) position scale;
          vrr = lib.mkIf display.vrr 1;
          transform = lib.mkIf display.vertical 1;
        }) cfg'.displays;

        workspace = self.lib.genWorkspaceList' (
          display: workspace: _:
          "${toString workspace}, monitor:${
            if display.connector == null then "desc:${display.make} ${display.model}" else display.connector
          }"
          + lib.optionalString (workspace == (lib.head display.workspaces)) ", default:true"
        ) cfg'.displays;

        env = lib.mkIf (!cfg'.wayland.uwsm.enable) (
          lib.mapAttrsToList (name: value: "${name}, ${toString value}") cfg'.wayland.sessionVariables
        );

        # HACK: Breaks Vesktop screensharing.
        # debug.full_cm_proto = true;
      };
    };
  };
}

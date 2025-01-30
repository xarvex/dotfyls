{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
{
  imports = [
    ./idle
    ./lock

    ./appearance.nix
    ./interaction.nix
    ./keybinds.nix
    ./rules.nix

    (self.lib.mkAliasPackageModule'
      [ "dotfyls" "desktops" "desktops" "hyprland" ]
      [ "wayland" "windowManager" "hyprland" ]
    )
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    explicitSync = lib.mkEnableOption "Hyprland explicit sync";
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls = {
      desktops = {
        dotpanel.enable = lib.mkDefault true;
        swww.enable = lib.mkDefault true;
      };

      # TODO: Confirm permissions.
      file.".cache/hyprland".cache = true;

      programs = {
        brightnessctl.enable = lib.mkDefault true;
        cliphist.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        wl-clipboard.enable = true;
      };
    };

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };

      settings = {
        xwayland.force_zero_scaling = true;

        render = rec {
          explicit_sync = if cfg.explicitSync then 1 else 0;
          explicit_sync_kms = explicit_sync;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        monitor =
          (lib.forEach cfg'.displays (
            display:
            builtins.concatStringsSep ", " (
              [
                display.name
                "${toString display.width}x${toString display.height}@${toString display.refresh}"
                display.position
                (toString display.scale)
              ]
              ++ lib.optionals display.vertical [ "transform, 1" ]
            )
          ))
          ++ [ ", preferred, auto, auto" ];

        workspace = self.lib.genWorkspaceList' (
          display: workspace: key:
          "${toString workspace}, monitor:${display.name}, key:${key}"
        ) cfg'.displays;

        env = lib.mapAttrsToList (name: value: "${name}, ${toString value}") cfg'.wayland.sessionVariables;
      };
    };
  };
}

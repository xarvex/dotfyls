{
  config,
  lib,
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
      [
        "dotfyls"
        "desktops"
        "desktops"
        "hyprland"
      ]
      [
        "wayland"
        "windowManager"
        "hyprland"
      ]
    )
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    explicitSync = lib.mkEnableOption "Hyprland explicit sync";
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls = {
      desktops.wayland.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      # TODO: Confirm permissions.
      file.".cache/hyprland".cache = true;

      programs = {
        brightnessctl.enable = lib.mkDefault true;
        cliphist.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swww.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        wl-clipboard.enable = true;
      };
    };

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

        monitor =
          (lib.forEach cfg'.displays (
            display:
            lib.concatStringsSep ", " (
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

        env = lib.mapAttrsToList (name: value: "${name}, ${toString value}") cfg'.wayland.sessionVariables;

        exec-once = [ "swww-daemon &" ];
      };
    };
  };
}

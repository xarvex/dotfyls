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
    explicitSync = lib.mkEnableOption "Hyprland explicit sync";
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls = {
      # TODO: Confirm permissions.
      files.".cache/hyprland".cache = true;

      media.gvfs.enable = lib.mkDefault true;
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
          (lib.forEach config.dotfyls.desktops.displays (
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

        env = builtins.attrValues (
          builtins.mapAttrs (name: value: "${name}, ${toString value}") (
            config.dotfyls.desktops.wayland.sessionVariables // { QT_WAYLAND_DISABLE_WINDOWDECORATION = 1; }
          )
        );

        exec-once = [ "swww-daemon &" ];
      };
    };
  };
}

{ config, lib, self, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
    ./keybinds.nix
    ./rules.nix

    (self.lib.mkAliasPackageModule
      [ "dotfyls" "desktops" "desktops" "hyprland" ]
      [ "wayland" "windowManager" "hyprland" ])
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    explicitSync = lib.mkEnableOption "Hyprland explicit sync";
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls = {
      programs = {
        cliphist.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        gvfs.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        wl-clipboard.enable = true;
      };

      persist.cacheDirectories = [ ".cache/hyprland" ];
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        env = builtins.attrValues (builtins.mapAttrs
          (name: value: "${name}, ${toString value}")
          (config.dotfyls.desktops.wayland.sessionVariables
            // { QT_WAYLAND_DISABLE_WINDOWDECORATION = 1; }));

        render = rec {
          explicit_sync = if cfg.explicitSync then 1 else 0;
          explicit_sync_kms = explicit_sync;
        };

        xwayland.force_zero_scaling = true;

        input = {
          kb_layout = "us";
          follow_mouse = 1;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = false;
          };
        };

        monitor = (lib.forEach config.dotfyls.desktops.displays (display:
          lib.concatStringsSep ", " ([
            display.name
            "${toString display.width}x${toString display.height}@${toString display.refresh}"
            display.position
            (toString display.scale)
          ] ++ lib.optionals display.vertical [ "transform, 1" ])
        )) ++ [ ", preferred, auto, auto" ];

        exec-once =
          let
            cliphist = config.dotfyls.programs.cliphist.package;
            wl-clipboard = config.dotfyls.programs.wl-clipboard.package;
          in
          [
            "${lib.getExe' wl-clipboard "wl-paste"} -w ${lib.getExe cliphist} store"
          ];
      };

      systemd = {
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };
    };
  };
}

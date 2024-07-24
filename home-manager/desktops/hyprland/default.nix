{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "desktops" "hyprland" "package" ]
      [ "wayland" "windowManager" "hyprland" "package" ])

    ./keybinds.nix
    ./rules.nix
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    sessionName = lib.mkOption {
      type = lib.types.str;
      default = "Hyprland";
      description = "XDG desktop session name.";
    };
    idle = {
      enable = lib.mkEnableOption "Hyprland idle" // { default = true; };
      provider = lib.mkOption {
        type = lib.types.enum [ "hypridle" "swayidle" ];
        default = "hypridle";
        example = "swayidle";
        description = "Idler to use.";
      };
      displays =
        let
          mkCommandOption = state: pkgs.lib.dotfyls.mkCommandOption "idle displays ${state}"
            // {
            default = pkgs.lib.dotfyls.mkCommand {
              runtimeInputs = [ cfg.package ];
              text = "hyprctl dispatch dpms ${state}";
            };
          };
        in
        {
          enable = lib.mkEnableOption "Hyprland display idle" // { default = true; };
          onCommand = mkCommandOption "on";
          offCommand = mkCommandOption "off";
        };
      suspend.enable = lib.mkEnableOption "Hyprland suspend idle" // { default = true; };
    };
    lock = {
      enable = lib.mkEnableOption "Hyprland lock" // { default = true; };
      provider = lib.mkOption {
        type = lib.types.enum [ "hyprlock" "swaylock" ];
        default = "hyprlock";
        example = "swaylock";
        description = "Locker to use.";
      };
    };
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        env = (
          let sessionVariables = config.dotfyls.desktops.wayland.sessionVariables; in
          (builtins.map (name: "${name}, ${toString sessionVariables.${name}}") (builtins.attrNames sessionVariables))
        );

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
            "1"
          ] ++ lib.optionals display.vertical [ "transform, 1" ])
        )) ++ [ ", preferred, auto, auto" ];

        exec-once = [
          "wl-paste --watch cliphist store"
        ];
      };

      systemd = {
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };
    };

    dotfyls.persist.directories = [ ".cache/hyprland" ]; # crash reports
  };
}

{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.social;
  cfg = cfg'.discord;
in
{
  options.dotfyls.social.discord = {
    enable = lib.mkEnableOption "Discord" // {
      default = true;
    };
    variant = lib.mkOption {
      type = lib.types.enum [
        "legcord"
        "official"
        "vesktop"
      ];
      default = "legcord";
      example = "vesktop";
      description = "Discord variant to use.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
    lib.mkMerge [
      (lib.mkIf (cfg.variant == "legcord") {
        dotfyls.file.".config/legcord" = {
          mode = "0700";
          cache = true;
        };

        home.packages = with pkgs; [ legcord ];

        wayland.windowManager.hyprland.settings = {
          bind = [ "SUPER, D, exec, ${lib.getExe pkgs.legcord}" ];
          windowrule = [
            "tag +popout, class:legcord, title:Discord Popout"

            "noscreenshare, class:legcord"
          ];
        };
      })

      (lib.mkIf (cfg.variant == "official") {
        dotfyls.file.".config/discord" = {
          mode = "0700";
          cache = true;
        };

        home.packages = with pkgs; [ discord ];

        wayland.windowManager.hyprland.settings = {
          bind = [ "SUPER, D, exec, ${lib.getExe pkgs.discord}" ];
          windowrule = [
            "tag +popout, class:discord, title:Discord Popout"

            "noscreenshare, class:discord"
          ];
        };
      })

      (lib.mkIf (cfg.variant == "vesktop") {
        dotfyls.file.".config/vesktop/sessionData" = {
          mode = "0700";
          cache = true;
        };

        wayland.windowManager.hyprland.settings = {
          bind = [
            "SUPER, D, exec, ${
              # HACK: Vesktop module does not provide the final package.
              lib.getExe (
                (self.lib.getCfgPkg config.programs.vesktop).override {
                  withSystemVencord = config.programs.vesktop.vencord.useSystem;
                }
              )
            }"

            # TODO: Set mute keybind. Cannot use Hyprland redirect, app must be focused.
            # See: https://github.com/hyprwm/Hyprland/issues/6576
            # Add bind once global shortcuts are implemented.
            # See: https://github.com/Vencord/Vesktop/issues/18
            # See: https://github.com/Vencord/Vesktop/pull/326
          ];
          windowrule = [
            "tag +popout, class:vesktop, title:Discord Popout"

            "noscreenshare, class:vesktop"
          ];
        };
      })
    ]
  );
}

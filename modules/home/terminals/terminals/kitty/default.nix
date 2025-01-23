{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.terminals.kitty;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "terminals" "terminals" "kitty" ] [ "programs" "kitty" ])
  ];

  options.dotfyls.terminals.terminals.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/kitty".cache = true;

    programs.kitty = {
      enable = true;

      font = {
        name = "monospace";
        size = cfg'.fontSize;
      };
      settings = {
        # Text cursor customization
        cursor_trail = 3;

        # Scrollback
        scrollback_lines = cfg'.scrollback;

        # Mouse
        strip_trailing_spaces = "never";

        # Terminal bell
        enable_audio_bell = false;
        window_alert_on_bell = false;

        # Window layout
        remember_window_size = false;

        # Color scheme
        background_opacity = toString cfg'.opacity;

        # Advanced
        update_check_interval = 0;
      };
      themeFile = "ChallengerDeep";
    };
  };
}

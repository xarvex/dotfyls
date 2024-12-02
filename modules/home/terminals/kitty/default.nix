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
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "terminals"
        "terminals"
        "kitty"
      ]
      [
        "programs"
        "kitty"
      ]
    )
  ];

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files.".config/kitty".cache = true;

    programs.kitty = {
      enable = true;

      font = {
        name = "monospace";
        size = cfg'.fontSize;
      };
      settings = {
        # Scrollback
        scrollback_lines = 10000;

        # Mouse
        strip_trailing_spaces = "never";

        # Terminal bell
        enable_audio_bell = false;
        window_alert_on_bell = false;

        # Window layout
        remember_window_size = false;

        # Color scheme
        background_opacity = toString 0.85;

        # Advanced
        update_check_interval = 0;
      };
      extraConfig = ''
        include themes.conf
      '';
    };
  };
}

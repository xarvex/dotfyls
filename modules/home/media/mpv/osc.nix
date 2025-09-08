{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpv;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.mpv = {
    config = {
      # Window
      border = false;

      # OSD
      osc = false;
    };
    scripts = with pkgs.mpvScripts; [
      modernz
      thumbfast
    ];
    scriptOpts = {
      modernz = {
        # Language and display
        window_top_bar = false;
        greenandgrumpy = true;

        # OSC behavior and scaling
        osc_on_start = true;

        # Buttons display and functionality
        chapter_skip_buttons = true;
        track_nextprev_buttons = false;
        fullscreen_button = false;
        info_button = false;

        # Colors and style
        seekbarfg_color = "#FFFFFF";
        seekbarbg_color = "#7F7F7F";
        hover_effect_color = "#7F7F7F";

        # Button hover effects
        hover_effect = builtins.concatStringsSep "," [
          "size"
          "glow"
        ];
      };
      thumbfast.hwdec = true;
    };
  };
}

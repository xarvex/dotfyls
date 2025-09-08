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
    scripts = with pkgs.mpvScripts; [
      eisa01.undoredo
      eisa01.smartskip
      sponsorblock-minimal
    ];
    scriptOpts = {
      SmartSkip = {
        # Silence Skip Settings
        add_chapter_on_skip = false;

        # Auto-Skip Settings
        autoskip_countdown = 0;
        skip_once = true;

        # Keybind Settings
        smart_next_keybind = builtins.toJSON [ "PGUP" ];
        smart_prev_keybind = builtins.toJSON [ "PGDWN" ];
      }
      // lib.genAttrs [
        "add_chapter_keybind"
        "remove_chapter_keybind"
        "edit_chapter_keybind"
        "write_chapters_keybind"
        "bake_chapters_keybind"
        "chapter_next_keybind"
        "chapter_prev_keybind"
      ] (_: builtins.toJSON [ ]);
      sponsorblock_minimal = {
        categories = builtins.toJSON [
          "intro"
          "sponsor"
        ];
        hash = true;
      };
    };
  };
}

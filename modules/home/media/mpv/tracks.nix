{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpv;

  jsonFormat = pkgs.formats.json { };

  englishLangs = [
    "en-us"
    "en"
    "eng"
    "english"
  ];
  swedishLangs = [
    "sv"
    "swe"
    "swedish"
  ];
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.mpv = {
    config =
      let
        lang = builtins.concatStringsSep "," (englishLangs ++ swedishLangs);
      in
      {
        # Track Selection
        alang = lang;
        slang = lang;
        vlang = lang;
      };
    scripts = [ self.packages.${pkgs.system}.mpv-sub-select ];
    scriptOpts.sub_select.observe_audio_switches = true;
  };

  xdg.configFile."mpv/script-opts/sub-select.json".source =
    jsonFormat.generate "mpv-script-opts-sub-select"
      (
        let
          mkSubSelection =
            attrs:
            let
              extraCondition = lib.optionalString (attrs ? condition) "and (${attrs.condition})";
            in
            [
              (attrs // { condition = ''sub.external and sub.codec == "ass"${extraCondition}''; })
              (attrs // { condition = ''sub.external and sub.codec == "srt"${extraCondition}''; })
              (attrs // { condition = ''sub.external${extraCondition}''; })
              (attrs // { condition = ''sub.codec == "ass"${extraCondition}''; })
              (attrs // { condition = ''sub.codec == "srt"${extraCondition}''; })
              attrs
            ];

          englishLangs = [
            "en%-us"
            "eng?"
            "english"
          ];
          swedishLangs = [
            "sv"
            "swe"
          ];
        in
        [
          {
            alang = englishLangs;
            slang = "no";
            condition = "not (${
              builtins.replaceStrings [ "path" ] [ ''mp.get_property("path", "")'' ]
                config.programs.mpv.profiles.media.profile-cond
            })";
          }
        ]
        ++ (mkSubSelection {
          alang = swedishLangs;
          slang = swedishLangs;
        })
        ++ (mkSubSelection {
          alang = [
            "ja"
            "jpn"
          ];
          slang = englishLangs ++ [ "und" ];
          blacklist = [ "sign" ];
        })
        ++ (mkSubSelection {
          alang = englishLangs;
          slang = englishLangs ++ [ "und" ];
          whitelist = [
            "sign"
            "song"
          ];
        })
        ++ (mkSubSelection {
          alang = "*";
          slang = englishLangs ++ [ "und" ];
        })
      );
}

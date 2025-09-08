{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.yt-dlp;
in
{
  imports = [ inputs.yt-dli.homeModules.yt-dli ];

  options.dotfyls.media.yt-dlp.enable = lib.mkEnableOption "yt-dlp" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/yt-dlp".cache = true;

    home.shellAliases.yt = if config.programs.yt-dlp.yt-dli.enable then "yt-dli" else "yt-dlp";

    programs.yt-dlp = {
      enable = true;

      settings = {
        # Filesystem Options
        paths = lib.escapeShellArg config.xdg.userDirs.videos;
        # `yt-dlp` will treat slashes as part of the filename if in a template.
        # Use `.` as alternative value to prevent this being interpreted as an absolute path.
        output = lib.escapeShellArg "%(playlist|.)s/%(playlist_index&{} - |)s%(title)s.%(ext)s";
        windows-filenames = true;
        mtime = true;

        # Video Format Options
        format = lib.escapeShellArg "bestvideo*+bestaudio / best";
        format-sort = "lang,quality,res,fps,hdr:12,channels,acodec,br,vcodec,asr,proto,ext,hasaud,source,id";
        video-multistreams = true;
        audio-multistreams = true;

        # Subtitle Options
        sub-format = builtins.concatStringsSep "/" [
          "ass"
          "srt"
          "best"
        ];
        sub-langs = builtins.concatStringsSep "," [
          "en"
          "en-us"
          "eng"
          "english"
          "sv"
          "swe"
          "swedish"
        ];

        # Post-Processing Options
        audio-quality = 0;
        embed-subs = true;
        embed-thumbnail = true;
        embed-metadata = true;
        embed-chapters = true;

        # SponsorBlock Options
        sponsorblock-mark = "all";

        # Extractor Options
        # extractor-args = "youtube:player_client=default,ios;formats=missing_pot";
      };

      yt-dli = {
        enable = true;

        profiles =
          let
            mkResFormat = res: lib.escapeShellArg "bestvideo*[height<=${toString res}]+bestaudio";
          in
          builtins.listToAttrs (
            map (res: lib.nameValuePair "${toString res}p" { settings.format = mkResFormat res; }) [
              720
              1080
              2160
            ]
          )
          // {
            music.settings = {
              # Filesystem Options
              paths = lib.escapeShellArg config.xdg.userDirs.music;

              # Video Format Options
              format = "bestaudio/bestaudio*";
              format-sort = "lang,quality,channels,acodec,br,vcodec,asr,proto,ext,hasaud,source,id";
              video-multistreams = false;

              # Post-Processing Options
              extract-audio = true;
              embed-subs = false;
              embed-thumbnail = false;
              embed-metadata = false;
              embed-chapters = false;

              # SponsorBlock Options
              sponsorblock = false;
            };

            video.settings = {
              # Filesystem Options
              paths = lib.escapeShellArg config.xdg.userDirs.videos;

              # Video Format Options
              merge-output-format = "mkv";

              # Post-Processing Options
              remux-video = "mkv";
            };
            movie = {
              references = "video";
              settings.paths = "${config.programs.yt-dlp.settings.paths}/Movies";
            };
            show = {
              references = "video";
              settings.paths = "${config.programs.yt-dlp.settings.paths}/Shows";
            };
          };
      };
    };
  };
}

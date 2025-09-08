{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpv;

  matchMovies = ''path:find("Movies") ~= nil'';
  matchShows = ''path:find("Shows") ~= nil'';
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.mpv.profiles = {
    media = {
      profile-desc = "Media content (autoswitch with directories)";
      profile-cond = "(${matchMovies}) or (${matchShows})";
      profile-restore = "copy-equal";

      # GPU Renderer Options
      dscale = "mitchell";
      cscale = "ewa_lanczos";
      cscale-blur = 1.015; # https://github.com/mpv-player/mpv/issues/10955#issuecomment-1335583399;
      interpolation = true;

      # Video Sync
      video-sync = "display-resample";
    };

    sequential = {
      profile-desc = "Sequential content (autoswitch with directories)";
      profile-cond = matchShows;

      # Demuxer
      autocreate-playlist = "same";
    };
    standalone = {
      profile-desc = "Standalone content (autoswitch with directories)";
      profile-cond = "not (${config.programs.mpv.profiles.sequential.profile-cond})";

      # Demuxer
      autocreate-playlist = "no";
    };

    short-form = {
      profile-desc = "Short-form content (autoswitch when shorter than 5 minutes)";
      profile-cond = "p.duration < ${toString (5 * 60)}";

      # Watch Later
      save-position-on-quit = false;
    };
    long-form = {
      profile-desc = "Long-form content (autoswitch when at least 5 minutes)";
      profile-cond = "not (${config.programs.mpv.profiles.short-form.profile-cond})";

      # Watch Later
      save-position-on-quit = true;
    };
  };
}

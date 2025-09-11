{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.firefox;

  profilePath = "${config.programs.firefox.profilesPath}/${config.programs.firefox.profiles.xarvex.path}";
  userjsPath = "${profilePath}/user.js";
in
lib.mkIf (cfg'.enable && cfg.enable) {
  home.file = {
    "${userjsPath}".enable = false;
    "dotfyls-${userjsPath}" = {
      target = "${userjsPath}";
      source =
        pkgs.runCommandLocal "dotfyls-${lib.strings.sanitizeDerivationName userjsPath}"
          {
            nativeBuildInputs = with pkgs; [ coreutils ];

            home_manager = config.home.file."${userjsPath}".source;
            arkenfox = "${pkgs.arkenfox-userjs}/user.js";
            user_overrides = ./user-overrides.js;
          }
          ''
            cat $home_manager $arkenfox $user_overrides >$out
          '';
    };
  };
}

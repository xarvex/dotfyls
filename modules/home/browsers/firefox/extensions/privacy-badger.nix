{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.extensions.settings."jid1-MnnxcxisBPnSXQ@jetpack".settings.settings_map.showIntroPage =
    false;
}

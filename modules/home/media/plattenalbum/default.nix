{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.plattenalbum;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "dotfyls" "media" "plattenalbum" "mpdPackage" ] [ "services" "mpd" ])
  ];

  options.dotfyls.media.plattenalbum = {
    enable = lib.mkEnableOption "Plattenalbum" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Plattenalbum" { default = "plattenalbum"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.mime-apps.media.audio = "de.wagnermartin.Plattenalbum.desktop";

    services.mpd = {
      enable = true;

      network.startWhenNeeded = true;
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}

{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.zathura;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "media" "zathura" ] [ "programs" "zathura" ])
  ];

  options.dotfyls.media.zathura.enable = lib.mkEnableOption "zathura" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/zathura" = {
      mode = "0700";
      cache = true;
    };

    programs.zathura.enable = true;
  };
}

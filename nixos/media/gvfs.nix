{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.gvfs;
  hmCfg = config.hm.dotfyls.media.gvfs;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "media"
        "gvfs"
      ]
      [
        "services"
        "gvfs"
      ]
    )
  ];

  options.dotfyls.media.gvfs.enable = lib.mkEnableOption "GVfs" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { services.gvfs.enable = true; };
}

{ config, lib, self, ... }:

let
  cfg = config.dotfyls.programs.gvfs;
  hmCfg = config.hm.dotfyls.programs.gvfs;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "gvfs" ]
      [ "services" "gvfs" ])
  ];

  options.dotfyls.programs.gvfs = {
    enable = lib.mkEnableOption "GVfs" // { default = hmCfg.enable; };
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}

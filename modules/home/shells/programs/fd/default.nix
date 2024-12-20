{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.fd;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "fd" ] [ "programs" "fd" ])
  ];

  options.dotfyls.shells.programs.fd.enable = lib.mkEnableOption "fd" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable {
    programs.fd = {
      enable = true;

      hidden = true;
    };
  };
}

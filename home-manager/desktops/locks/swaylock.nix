{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.locks;
  cfg = cfg'.locks.swaylock;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "desktops"
        "locks"
        "locks"
        "swaylock"
      ]
      [
        "programs"
        "swaylock"
      ]
    )
  ];

  options.dotfyls.desktops.locks.locks.swaylock = {
    enable = lib.mkEnableOption "swaylock";
    command =
      self.lib.mkCommandOption "invoke swaylock"
      // lib.optionalAttrs cfg.enable { default = self.lib.getCfgPkg cfg; };
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    programs.swaylock = {
      enable = true;

      # TODO: theme
    };
  };
}

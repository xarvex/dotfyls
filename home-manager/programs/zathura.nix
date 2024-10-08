{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.zathura;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "zathura"
      ]
      [
        "programs"
        "zathura"
      ]
    )
  ];

  options.dotfyls.programs.zathura.enable = lib.mkEnableOption "zathura" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { programs.zathura.enable = true; };
}

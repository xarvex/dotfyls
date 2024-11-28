{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.flatpak;
  hmCfg = config.hm.dotfyls.programs.flatpak;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "flatpak"
      ]
      [
        "services"
        "flatpak"
      ]
    )
  ];

  options.dotfyls.programs.flatpak.enable = lib.mkEnableOption "Flatpak" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.files.cacheDirectories = [ "/var/lib/flatpak" ];

    services.flatpak.enable = true;
  };
}

{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.dunst;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "dunst"
      ]
      [
        "services"
        "dunst"
      ]
    )
  ];

  options.dotfyls.programs.dunst.enable = lib.mkEnableOption "Dunst";

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      # TODO: theme
    };
  };
}

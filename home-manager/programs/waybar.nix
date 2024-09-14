{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.waybar;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "waybar"
      ]
      [
        "programs"
        "waybar"
      ]
    )
  ];

  options.dotfyls.programs.waybar.enable = lib.mkEnableOption "Waybar";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # TODO: theme
    };
  };
}

{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.obsidian;
in
{
  options.dotfyls.files.obsidian = {
    enable = lib.mkEnableOption "Obsidian" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Obsidian" { default = "obsidian"; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      file.".config/obsidian" = {
        mode = "0700";
        cache = true;
      };

      mime-apps.extraSchemes.obsidian = "obsidian.desktop";
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}

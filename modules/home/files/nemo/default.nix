{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.nemo;
in
{
  options.dotfyls.files.nemo = {
    enable = lib.mkEnableOption "Nemo" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Nemo" { default = "nemo-with-extensions"; };
    finalPackage = self.lib.mkFinalPackageOption "Nemo" // {
      default = pkgs.symlinkJoin {
        inherit (cfg.package) name meta;

        paths =
          [ cfg.package ]
          ++ (with pkgs; [
            nemo-fileroller
            webp-pixbuf-loader
          ]);
      };
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      file.".cache/thumbnails" = {
        mode = "0700";
        cache = true;
      };

      files = {
        file-roller.enable = lib.mkDefault true;
        gvfs.enable = true;
      };

      mime-apps.files.directory = "nemo.desktop";
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    dconf.settings."org/nemo/preferences" = {
      click-double-parent-folder = true;
      close-device-view-on-device-eject = true;
      quick-renames-with-pause-in-between = true;
      show-advanced-permissions = true;
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 (1024 * 1024 * 1024);
    };
  };
}

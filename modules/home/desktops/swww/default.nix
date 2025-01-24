{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops.swww;
in
{
  options.dotfyls.desktops.swww = {
    enable = lib.mkEnableOption "swww" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "swww" { };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/swww".cache = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    systemd.user.services.swww = {
      Unit = {
        Description = "A Solution to your Wayland Wallpaper Woes";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };

      Service = {
        ExecStart = lib.getExe' cfg.package "swww-daemon";
        ExecStartPost = "${lib.getExe cfg.package} restore";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.desktops.swww;
in
{
  options.dotfyls.desktops.swww.enable = lib.mkEnableOption "swww" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/swww".cache = true;

    home.packages = with pkgs; [ swww ];

    systemd.user.services.swww = {
      Unit = {
        Description = "A Solution to your Wayland Wallpaper Woes";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };

      Service = {
        ExecStart = lib.getExe' pkgs.swww "swww-daemon";
        ExecStartPost = "${lib.getExe pkgs.swww} restore";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}

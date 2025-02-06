{
  config,
  lib,
  pkgs,
  ...
}:

{
  dotfyls = {
    appearance = {
      enable = true;
      fonts.enable = true;
    };

    desktops.enable = false;

    files.sync.enable = false;

    security.yubikey.enable = false;

    terminals = {
      enable = true;
      default = "foot";
    };
  };

  home.packages = with pkgs; [ gitMinimal ];

  programs.bash.profileExtra = ''
    if [ "$(${lib.getExe' pkgs.coreutils "tty"})" = "/dev/tty1" ]; then
        WLR_RENDERER=pixman exec ${lib.getExe' pkgs.dbus "dbus-run-session"} ${lib.getExe pkgs.cage} -ds -- ${lib.getExe config.programs.foot.package}
    fi
  '';

  dconf.enable = false;
}

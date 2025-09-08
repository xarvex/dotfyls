{
  config,
  lib,
  pkgs,
  self,
  ...
}:

{
  dotfyls = {
    appearance = {
      enable = true;
      fonts.enable = true;
    };

    desktops.enable = false;

    terminals = {
      enable = true;
      default = "foot";
    };
  };

  home.packages = with pkgs; [
    gitMinimal
    wl-clipboard
  ];

  programs.bash.profileExtra =
    # bash
    ''
      if [ "$(${lib.getExe' pkgs.coreutils "tty"})" = "/dev/tty1" ]; then
          WLR_RENDERER=pixman exec ${lib.getExe pkgs.cage} -ds -- ${self.lib.getCfgExe config.programs.foot}
      fi
    '';

  dconf.enable = false;
}

{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.locks.locks.hyprlock;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "locks" "locks" "swaylock" "package" ]
      [ "programs" "swaylock" "package" ])
  ];

  options.dotfyls.desktops.locks.locks.swaylock = {
    enable = lib.mkEnableOption "swaylock";
    command = pkgs.lib.dotfyls.mkCommandOption "invoke swaylock"
      // lib.optionalAttrs cfg.enable { default = pkgs.swaylock; };
  };

  config = lib.mkIf config.dotfyls.desktops.locks.locks.swaylock.enable {
    programs.swaylock = {
      enable = true;

      # TODO: theme
    };
  };
}

{ config, lib, pkgs, self, ... }:

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
    command = self.lib.mkCommandOption "invoke swaylock"
      // lib.optionalAttrs cfg.enable { default = pkgs.swaylock; };
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;

      # TODO: theme
    };
  };
}

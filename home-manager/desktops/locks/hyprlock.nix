{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.locks.locks.hyprlock;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "locks" "locks" "hyprlock" "package" ]
      [ "programs" "hyprlock" "package" ])
  ];

  options.dotfyls.desktops.locks.locks.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
    command = pkgs.lib.dotfyls.mkCommandOption "invoke hyprlock"
      // lib.optionalAttrs cfg.enable {
      default = pkgs.lib.dotfyls.mkCommand {
        runtimeInputs = [ cfg.package pkgs.procps ];
        text = "pidof hyprlock || exec hyprlock";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        disable_loading_bar = true;
        # TODO: theme
      };
    };
  };
}

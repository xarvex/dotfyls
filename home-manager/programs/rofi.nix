{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.rofi;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "rofi" ]
      [ "programs" "rofi" ])
  ];

  options.dotfyls.programs.rofi.enable = lib.mkEnableOption "Rofi";

  config = lib.mkIf cfg.enable {
    dotfyls.programs.rofi.package = lib.mkDefault pkgs.rofi-wayland;

    programs.rofi = {
      enable = true;

      terminal = (lib.mkIf (config.dotfyls.terminals.xdgExec != null) (lib.getExe config.dotfyls.terminals.xdgExec));
    };
  };
}

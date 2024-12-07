{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
{
  imports = [
    ./lock.nix

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "desktops"
        "desktops"
        "hyprland"
      ]
      [
        "programs"
        "hyprland"
      ]
    )
  ];

  options.dotfyls.desktops.desktops.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}

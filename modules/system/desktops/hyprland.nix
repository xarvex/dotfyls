{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
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

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls.media = {
      enable = lib.mkDefault true;
      gvfs.enable = lib.mkDefault true;
      pipewire.enable = lib.mkDefault true;
    };

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}

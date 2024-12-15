{ lib, ... }:

{
  dotfyls = {
    desktops = {
      wayland.sessionVariables.NIXOS_OZONE_WL = lib.mkForce "";
      displays = [
        {
          name = "DP-2";
          width = 3840;
          height = 2160;
          refresh = 144;
        }
      ];
      desktops.hyprland.explicitSync = true;
    };

    programs.openrgb.enable = true;
  };
}

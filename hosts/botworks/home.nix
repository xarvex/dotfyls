{ options, ... }:

{
  dotfyls = {
    programs.openrgb.enable = true;

    terminals.default = "kitty"; # WezTerm breaks on NVIDIA.

    desktops = {
      wayland.sessionVariables = options.dotfyls.desktops.wayland.sessionVariables.default // {
        NIXOS_OZONE_WL = "";
      };

      displays = [
        {
          name = "DP-2";
          width = 3840;
          height = 2160;
          refresh = 144;
        }
      ];

      # Revert when Firefox behaves:
      # desktops.hyprland.explicitSync = true;
    };
  };
}

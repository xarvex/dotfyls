{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops;
  hmCfg = config.hm.dotfyls.desktops;
in
{
  imports = [
    ./hyprland

    (self.lib.mkSelectorModule [ "dotfyls" "desktops" ] {
      name = "default";
      inherit (hmCfg) default;
      example = "hyprland";
      description = "Default desktop to use.";
    })
  ];

  options.dotfyls.desktops.enable = lib.mkEnableOption "desktops" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    services.xserver = {
      updateDbusEnvironment = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [ xterm ];
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };
  };
}

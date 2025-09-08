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
    ./hyprland.nix
    ./portal.nix
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // {
      default = hmCfg.enable;
    };
    default = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
      inherit (hmCfg) default;
      example = "hyprland";
      description = "Default desktop to use.";
    };

    hyprlock.enable = lib.mkEnableOption "hyprlock" // {
      default = hmCfg.hyprlock.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.desktops = self.lib.enableSelected cfg.default [ "hyprland" ];

    environment.pathsToLink = [ "/share/applications" ];

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

      pam.services.hyprlock.u2fAuth = cfg.hyprlock.enable && config.security.pam.services.login.u2fAuth;
    };
  };
}

{ config, lib, pkgs, self, user, ... }:

let
  cfg = config.dotfyls.desktops;
  hmCfg = config.hm.dotfyls.desktops;
in
{
  imports = [
    ./hyprland.nix
    ./locks.nix

    (self.lib.mkSelectorModule [ "dotfyls" "desktops" ]
      {
        name = "default";
        default = hmCfg.default;
        example = "hyprland";
        description = "Default desktop to use.";
      }
      [
        "hyprland"
      ])

    (self.lib.mkCommonModules [ "dotfyls" "desktops" "desktops" ]
      (desktop: dCfg: {
        enable = lib.mkEnableOption desktop.name // { default = desktop.hmCfg.enable; };
        startCommand = pkgs.lib.dotfyls.mkCommandOption "start ${desktop.name}";
      })
      {
        hyprland = let cfg' = cfg.desktops.hyprland; in {
          name = "Hyprland";
          hmCfg = hmCfg.desktops.hyprland;
          specialArgs.startCommand.default = pkgs.lib.dotfyls.mkDbusSession cfg'.package;
        };
      })
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // { default = hmCfg.enable; };
    startCommand = pkgs.lib.dotfyls.mkCommandOption "start default desktop" // {
      default = pkgs.lib.dotfyls.mkCommand ''
        if [ "$(${lib.getExe' pkgs.coreutils "whoami"})" = ${user} ]; then
          exec ${lib.getExe hmCfg.startCommand}
        else
          exec ${lib.getExe cfg.selected.startCommand}
        fi
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      updateDbusEnvironment = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [ xterm ];
    };

    security.polkit.enable = true;
  };
}

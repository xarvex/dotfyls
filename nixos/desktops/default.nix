{ config, lib, pkgs, self, ... }:

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
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // { default = hmCfg.enable; };
    launchCommand = pkgs.lib.dotfyls.mkCommandOption "launch default desktop"
      // { default = cfg.selected.command; };
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

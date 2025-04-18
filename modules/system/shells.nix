{ config, lib, ... }:

let
  cfg = config.dotfyls.shells;
  hmCfg = config.hm.dotfyls.shells;
in
{
  options.dotfyls.shells.shells = {
    fish.enable = lib.mkEnableOption "Fish" // {
      default = hmCfg.shells.fish.enable;
    };
    zsh.enable = lib.mkEnableOption "Zsh" // {
      default = hmCfg.shells.zsh.enable;
    };
  };

  config = {
    environment.shellAliases = lib.mkForce { };

    programs = {
      fish.enable = lib.mkIf cfg.shells.fish.enable true;
      zsh.enable = lib.mkIf cfg.shells.zsh.enable true;
    };
  };
}

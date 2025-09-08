{ config, lib, ... }:

let
  cfg = config.dotfyls.shells;
  hmCfg = config.hm.dotfyls.shells;
in
{
  options.dotfyls.shells = {
    fish.enable = lib.mkEnableOption "Fish" // {
      default = hmCfg.fish.enable;
    };
    zsh.enable = lib.mkEnableOption "Zsh" // {
      default = hmCfg.zsh.enable;
    };
  };

  config = {
    environment.shellAliases = lib.mkForce { };

    programs = {
      fish.enable = cfg.fish.enable;
      zsh.enable = cfg.zsh.enable;
    };
  };
}

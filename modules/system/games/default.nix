{ config, lib, ... }:

let
  hmCfg = config.hm.dotfyls.games;
in
{
  imports = [ ./steam.nix ];

  options.dotfyls.games.enable = lib.mkEnableOption "games" // {
    default = hmCfg.enable;
  };
}

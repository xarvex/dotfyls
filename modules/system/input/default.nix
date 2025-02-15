{ config, lib, ... }:

let
  hmCfg = config.hm.dotfyls.input;
in
{
  imports = [
    ./solaar.nix
    ./uinput.nix
  ];

  options.dotfyls.input.enable = lib.mkEnableOption "input" // {
    default = hmCfg.enable;
  };
}

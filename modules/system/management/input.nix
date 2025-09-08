{ config, lib, ... }:

let
  cfg = config.dotfyls.management.input;
  hmCfg = config.hm.dotfyls.management.input;
in
{
  options.dotfyls.management.input = {
    useUinput = lib.mkEnableOption "uinput" // {
      default = hmCfg.useUinput;
    };
    useInput = lib.mkEnableOption "input" // {
      default = hmCfg.useInput;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.useUinput {
      hardware.uinput.enable = true;

      users.groups.uinput.members = [ config.dotfyls.meta.user ];
    })

    (lib.mkIf cfg.useInput {
      users.groups.input.members = [ config.dotfyls.meta.user ];
    })
  ];
}

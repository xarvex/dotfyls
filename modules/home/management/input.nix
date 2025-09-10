{ config, lib, ... }:

{
  options.dotfyls.management.input = {
    numlockDefault = lib.mkEnableOption "numlock by default" // {
      default = config.dotfyls.meta.machine.isDesktop || config.dotfyls.meta.machine.isLaptop;
    };
    useUinput = lib.mkEnableOption "uinput";
    useInput = lib.mkEnableOption "input";
  };
}

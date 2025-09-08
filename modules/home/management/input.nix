{ lib, ... }:

{
  options.dotfyls.management.input = {
    useUinput = lib.mkEnableOption "uinput";
    useInput = lib.mkEnableOption "input";
  };
}

{ lib, ... }:

{
  options.dotfyls.input.uinput = {
    enable = lib.mkEnableOption "uinput";
    inputGroup = lib.mkEnableOption "add input group to user";
  };
}

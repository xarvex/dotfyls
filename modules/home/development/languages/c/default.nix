{ lib, ... }:

{
  options.dotfyls.development.languages.c.enable = lib.mkEnableOption "C" // {
    default = true;
  };
}

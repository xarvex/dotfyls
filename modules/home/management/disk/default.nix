{ lib, ... }:

{
  imports = [ ./info.nix ];

  options.dotfyls.management.disk.enable = lib.mkEnableOption "disk management" // {
    default = true;
  };
}

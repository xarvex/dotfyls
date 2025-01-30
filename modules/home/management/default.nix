{ lib, ... }:

{
  imports = [
    ./btop
    ./nvtop
  ];

  options.dotfyls.management.enable = lib.mkEnableOption "management" // {
    default = true;
  };
}

{ lib, ... }:

{
  imports = [
    ./btop.nix
    ./nvtop.nix
  ];

  options.dotfyls.management.usage.enable = lib.mkEnableOption "usage management" // {
    default = true;
  };
}

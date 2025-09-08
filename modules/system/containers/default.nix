{ lib, ... }:

{
  imports = [
    ./flatpak.nix
    ./podman.nix
    ./virt-manager.nix
  ];

  options.dotfyls.containers.enable = lib.mkEnableOption "containers" // {
    default = true;
  };
}

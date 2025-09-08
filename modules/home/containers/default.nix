{
  lib,
  osConfig ? null,
  ...
}:

let
  osCfg = if osConfig == null then null else osConfig.dotfyls.containers;
in
{
  imports = [
    ./distrobox

    ./flatpak.nix
    ./podman.nix
    ./virt-manager.nix
  ];

  options.dotfyls.containers.enable = lib.mkEnableOption "containers" // {
    default = osCfg != null && osCfg.enable;
  };
}

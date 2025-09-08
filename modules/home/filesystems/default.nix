{
  lib,
  osConfig ? null,
  self,
  ...
}:

let
  osCfg = if osConfig == null then null else osConfig.dotfyls.filesystems;
in
{
  imports = [
    self.homeModules.filesystems_drives

    ./zfs.nix
  ];

  options.dotfyls.filesystems.impermanence.enable = lib.mkEnableOption "filesystem impermanence" // {
    default = osCfg.impermanence.enable;
  };
}

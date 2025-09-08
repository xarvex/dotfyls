# TODO: Combine with rest of config.
{
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment = {
    systemPackages = [ self.packages.${pkgs.system}.dotfyls-install ];
    sessionVariables.DOTFYLS_FLAKE = self;
  };

  networking = {
    wireless.enable = lib.mkImageMediaOverride false;
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}

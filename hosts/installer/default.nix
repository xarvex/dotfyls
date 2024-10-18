# TODO: combine with rest of config
{ lib, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  # TODO: rework installer when attributes are passed through.
  # environment.systemPackages = [ self.packages.${pkgs.system}.dotfyls-install ];

  networking = {
    wireless.enable = lib.mkImageMediaOverride false;
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}

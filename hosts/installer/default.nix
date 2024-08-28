# TODO: combine with rest of config
{ lib, modulesPath, pkgs, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "dotfyls-install";
      text = builtins.readFile ../../install.sh;
    })
  ];

  networking = {
    wireless.enable = lib.mkImageMediaOverride false;
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}

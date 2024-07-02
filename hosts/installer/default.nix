{ modulesPath, pkgs, ... }:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "dotfyls-install";
      text = builtins.readFile ../../install.sh;
    })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}

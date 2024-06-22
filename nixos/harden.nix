{ config, lib, pkgs, ... }:

{
  options.custom.harden.enable = lib.mkEnableOption "Enable system hardening" // { default = true; };

  config = lib.mkIf config.custom.harden.enable {
    boot.kernelPackages =
      let
        latestCompatibleVersion = config.boot.zfs.package.latestCompatibleLinuxPackages.kernel.version;
        hardenedPackages = lib.filterAttrs (name: packages: lib.hasSuffix "_hardened" name && (builtins.tryEval packages).success) pkgs.linuxKernel.packages;
        compatiblePackages = builtins.filter (packages: builtins.compareVersions packages.kernel.version latestCompatibleVersion <= 0) (builtins.attrValues hardenedPackages);
        orderedCompatiblePackages = builtins.sort (x: y: builtins.compareVersions x.kernel.version y.kernel.version > 0) compatiblePackages;
      in
      builtins.head orderedCompatiblePackages;
  };
}

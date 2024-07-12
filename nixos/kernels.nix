{ config, lib, pkgs, ... }:

{
  options.dotfyls.kernels = {
    variant = lib.mkOption {
      type = lib.types.enum [ "hardened" "stable" "zen" ];
      default = "stable";
      example = "hardened";
      description = "Variant of kernel to use.";
    };
    version = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = pkgs.linux_latest.version;
      description = "Explicit version of kernel to attempt match.";
    };
  };

  config =
    let
      cfg = config.dotfyls.kernels;

      kernelFilters = {
        hardened = kernel: kernel.isHardened;
        stable = kernel: kernel.pname == "linux" && kernel.meta.branch != "testing";
        zen = kernel: kernel.isZen;
      };

      kernelPackagesFor = filter: version:
        let
          list = builtins.filter (packages: (builtins.tryEval packages).success && builtins.isAttrs packages) (builtins.attrValues pkgs.linuxKernel.packages);
          matched = builtins.filter (packages: filter packages.kernel && (version == null || builtins.compareVersions packages.kernel.version version <= 0)) list;
          ordered = builtins.sort (a: b: builtins.compareVersions a.kernel.version b.kernel.version > 0) matched;
        in
        builtins.head ordered;
    in
    {
      boot.kernelPackages = kernelPackagesFor kernelFilters.${cfg.variant} cfg.version;
    };
}

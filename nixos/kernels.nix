{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.kernels;

  kernelFilters = {
    hardened = kernel: kernel.isHardened;
    lqx = kernel: kernel.pname == "linux-lqx";
    stable = kernel: kernel.pname == "linux" && kernel.meta.branch != "testing";
    xanmod = kernel: kernel.pname == "linux-xanmod";
    zen = kernel: kernel.pname == "linux-zen";
  };

  kernelPackagesFor =
    filter: version:
    let
      list = builtins.filter (
        packages: (builtins.tryEval packages).success && builtins.isAttrs packages
      ) (builtins.attrValues pkgs.linuxKernel.packages);
      matched = builtins.filter (
        packages:
        filter packages.kernel
        && (version == null || builtins.compareVersions packages.kernel.version version <= 0)
      ) list;
      ordered = builtins.sort (
        a: b: builtins.compareVersions a.kernel.version b.kernel.version > 0
      ) matched;
    in
    builtins.head ordered;
in
{
  options.dotfyls.kernels = {
    variant = lib.mkOption {
      type = lib.types.enum [
        "hardened"
        "lqx"
        "stable"
        "xanmod"
        "zen"
      ];
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

  config = {
    boot.kernelPackages = kernelPackagesFor kernelFilters.${cfg.variant} cfg.version;
  };
}

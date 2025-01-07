{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.boot.kernel;

  kernelFilters = {
    hardened = kernel: kernel.isHardened;
    lqx = kernel: kernel.pname == "linux-lqx";
    stable = kernel: kernel.pname == "linux" && kernel.meta.branch != "testing";
    xanmod = kernel: kernel.pname == "linux-xanmod";
    zen = kernel: kernel.pname == "linux-zen";
  };
  kernelFilter = kernelFilters.${cfg.variant};
in
{
  imports = [
    (lib.mkAliasOptionModule [ "dotfyls" "boot" "kernel" "packages" ] [ "boot" "kernelPackages" ])
  ];

  options.dotfyls.boot.kernel.variant = lib.mkOption {
    type = lib.types.enum (builtins.attrNames kernelFilters);
    default = "stable";
    example = "hardened";
    description = "Variant of kernel to use.";
  };

  config = {
    dotfyls.boot.kernel.packages = lib.mkDefault (
      lib.pipe pkgs.linuxKernel.packages [
        builtins.attrValues
        (builtins.filter (
          kPkgs: (builtins.tryEval kPkgs).success && kPkgs ? kernel && kernelFilter kPkgs.kernel
        ))
        (builtins.sort (a: b: lib.versionOlder a.kernel.version b.kernel.version))
        lib.last
      ]
    );
  };
}

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
    ./blacklist.nix
    ./harden.nix
  ];

  options.dotfyls.boot.kernel = {
    variant = lib.mkOption {
      type = lib.types.enum (builtins.attrNames kernelFilters);
      default = "stable";
      example = "xanmod";
      description = "Variant of kernel to use.";
    };
    filterBroken = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of kernel module names used to filter a kernel without any marked broken.";
    };
  };

  config = {
    security.protectKernelImage = true;

    boot.kernelPackages = lib.pipe pkgs.linuxKernel.packages [
      builtins.attrValues
      (builtins.filter (
        kPkgs: (builtins.tryEval kPkgs).success && kPkgs ? kernel && kernelFilter kPkgs.kernel
      ))
      (builtins.filter (kPkgs: !(builtins.any (module: kPkgs.${module}.meta.broken) cfg.filterBroken)))
      (builtins.sort (a: b: lib.versionOlder a.kernel.version b.kernel.version))
      lib.last
    ];
  };
}

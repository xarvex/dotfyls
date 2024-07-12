{ lib, pkgs, ... }:

{
  latestCompatible = type: version:
    let
      matched = lib.filterAttrs (name: packages: lib.hasSuffix "_${type}" name && (builtins.tryEval packages).success) pkgs.linuxKernel.packages;
      compatible = builtins.filter (packages: builtins.compareVersions packages.kernel.version version <= 0) (builtins.attrValues matched);
      ordered = builtins.sort (a: b: builtins.compareVersions a.kernel.version b.kernel.version > 0) compatible;
    in
    builtins.head ordered;
}

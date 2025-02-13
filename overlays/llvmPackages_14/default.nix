{ inputs }:
final: prev:

assert (
  final.lib.assertMsg (
    prev.llvmPackages_14.lldb.outputs == [
      "out"
      "dev"
      "lib"
    ]
  ) "llvmPackages_14 had symlink fix merged, remove overlay"
);
prev.llvmPackages_14
// {
  inherit (inputs.nixpkgs-master.legacyPackages.${final.system}.llvmPackages_14)
    lldb
    ;
}

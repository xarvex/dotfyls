{ lib }:

rec {
  mkStaticPackageOption =
    pkg:
    lib.mkOption {
      internal = true;
      readOnly = true;
      type = lib.types.package;
      default = pkg;
    };

  mkExtraPackagesOption =
    name:
    lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = "Extra packages available to ${name}.";
    };

  getCfgPkg = cfg: cfg.finalPackage or cfg.package;
  getCfgExe' = cfg: exe: lib.getExe' (getCfgPkg cfg) exe;
  getCfgExe = cfg: lib.getExe (getCfgPkg cfg);
}

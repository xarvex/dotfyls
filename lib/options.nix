{ lib }:

rec {
  mkFinalPackageOption = name: lib.mkOption {
    readOnly = true;
    type = lib.types.package;
    description = "Resulting ${name} package.";
  };

  mkExtraPackagesOption = name: lib.mkOption {
    type = with lib.types; listOf package;
    default = [ ];
    description = "Extra packages available to ${name}.";
  };

  mkCommandOption = action: lib.mkOption {
    type = lib.types.package;
    description = "Command used to ${action}.";
  };

  getCfgPkg = cfg: cfg.finalPackage or cfg.package;
  getCfgExe' = cfg: exe: lib.getExe' (getCfgPkg cfg) exe;
  getCfgExe = cfg: lib.getExe (getCfgPkg cfg);
}

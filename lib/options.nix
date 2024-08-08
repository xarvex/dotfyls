{ lib }:

{
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
}

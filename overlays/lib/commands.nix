{ lib, pkgs, ... }:

rec {
  mkCommand = exec:
    if lib.isDerivation exec then exec else
    pkgs.writeShellApplication (
      (if lib.isString exec then { text = exec; } else exec)
      // { name = "dotfyls-command"; }
    );
  mkCommandExe = exec: lib.getExe (mkCommand exec);

  mkNamedCommand = name: exec: pkgs.writeShellApplication (
    (if lib.isDerivation exec then { text = lib.getExe exec; }
    else if lib.isString exec then { text = exec; } else exec)
    // { name = name; }
  );

  mkCommandOption = action: lib.mkOption {
    type = lib.types.package;
    description = "Command used to ${action}.";
  };
}

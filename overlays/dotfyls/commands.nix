{ lib, writeShellApplication }:

rec {
  mkCommand' =
    name: exec:
    if lib.isDerivation exec then
      exec
    else
      writeShellApplication (
        (if builtins.isString exec then { text = exec; } else exec) // { inherit name; }
      );
  mkCommand = exec: mkCommand' "dotfyls-command" exec;

  mkCommandExe = exec: lib.getExe (mkCommand exec);
}

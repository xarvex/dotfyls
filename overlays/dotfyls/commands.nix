{
  lib,
  pkgs,
  writeShellApplication,
}:

rec {
  mkCommand' =
    name: exec:
    if lib.isDerivation exec then
      exec
    else
      writeShellApplication ((if lib.isString exec then { text = exec; } else exec) // { inherit name; });
  mkCommand = exec: mkCommand' "dotfyls-command" exec;

  mkCommandExe = exec: lib.getExe (mkCommand exec);

  mkDbusSession =
    pkg:
    mkCommand' "dbus-${pkg.pname}-session" "exec ${lib.getExe' pkgs.dbus "dbus-run-session"} ${lib.getExe pkg}";
}

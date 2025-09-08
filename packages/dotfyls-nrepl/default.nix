{
  dash,
  hostname,
  lib,
  resholve,
}:

resholve.mkDerivation {
  pname = "dotfyls-nrepl";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./repl.nix
      ./script.sh
    ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D repl.nix  $out/usr/share/dotfyls-nrepl/repl.nix
    install -D script.sh $out/bin/nrepl

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/nrepl" ];
    interpreter = lib.getExe dash;
    inputs = [ hostname ];
    fake.external = [ "nix" ];
    fix."$NREPL_REPL" = [ "${placeholder "out"}/usr/share/dotfyls-nrepl/repl.nix" ];
  };

  meta = {
    description = "Convenience wrapper around nix repl that aims for a nicer out-of-the-box experience";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "nrepl";
    platforms = lib.platforms.linux;
  };
}

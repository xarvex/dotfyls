{
  coreutils,
  dash,
  lib,
  networkmanager,
  resholve,
}:

resholve.mkDerivation {
  pname = "dotfyls-nm-radio-toggle";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./script.sh ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D script.sh $out/bin/nm-radio-toggle

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/nm-radio-toggle" ];
    interpreter = lib.getExe dash;
    inputs = [
      coreutils
      networkmanager
    ];
    execer = [ "cannot:${lib.getExe' networkmanager "nmcli"}" ];
  };

  meta = {
    description = "Easy on/off toggling of radio connectivity with NetworkManager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "nm-radio-toggle";
    platforms = lib.platforms.linux;
  };
}

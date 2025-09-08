{
  coreutils,
  crudini,
  dash,
  gawk,
  lib,
  procps,
  resholve,
  wget,
}:

resholve.mkDerivation {
  pname = "dotfyls-qbittorrent-proton-forward";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./script.sh ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D script.sh $out/bin/qbittorrent-proton-forward

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/qbittorrent-proton-forward" ];
    interpreter = lib.getExe dash;
    inputs = [
      coreutils
      crudini
      gawk
      procps
      wget
    ];
    execer = [
      "cannot:${lib.getExe crudini}"
      "cannot:${lib.getExe wget}"
    ];
  };

  meta = {
    description = "Interoperation with Proton VPN's port forwarding to select session port in qBittorrent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "qbittorrent-proton-forward";
    platforms = lib.platforms.linux;
  };
}

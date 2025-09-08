{
  coreutils,
  dash,
  lib,
  nftables,
  resholve,
}:

resholve.mkDerivation {
  pname = "dotfyls-proton-forward";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./script.sh ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D script.sh $out/bin/proton-forward

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/proton-forward" ];
    interpreter = lib.getExe dash;
    inputs = [
      coreutils
      nftables
    ];
  };

  meta = {
    description = "Poke holes in Proton VPN's interface for port forwarding through firewalls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "proton-forward";
    platforms = lib.platforms.linux;
  };
}

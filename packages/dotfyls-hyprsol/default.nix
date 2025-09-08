{
  coreutils,
  dash,
  hyprland,
  lib,
  resholve,
}:

resholve.mkDerivation {
  pname = "dotfyls-hyprsol";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./script.sh ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D script.sh $out/bin/hyprsol

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/hyprsol" ];
    interpreter = lib.getExe dash;
    inputs = [
      coreutils
      hyprland
    ];
  };

  meta = {
    description = "Wrapper around hyprsunset that allows for smooth transitions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "hyprsol";
    platforms = lib.platforms.linux;
  };
}

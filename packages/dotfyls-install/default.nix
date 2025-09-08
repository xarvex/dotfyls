{
  coreutils,
  cryptsetup,
  dash,
  dosfstools,
  gawk,
  git,
  gnugrep,
  gptfdisk,
  hostname,
  jq,
  lib,
  ncurses,
  nixos-enter,
  nixos-generators,
  nixos-install,
  resholve,
  systemd,
  util-linux,
  which,
  zfs,
}:

(resholve.mkDerivation {
  pname = "dotfyls-install";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./script.sh ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D script.sh $out/bin/dotfyls-install

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/bin/dotfyls-install --replace-fail 'command_present ' 'command --id=@command_present@ '
    substituteInPlace $out/bin/dotfyls-install --replace-fail 'run_sudo ' 'command --id=@run_sudo@ '
    substituteInPlace $out/bin/dotfyls-install --replace-fail 'run ' 'command --id=@run@ '
    substituteInPlace $out/bin/dotfyls-install --replace-fail 'sudo ' 'command --id=@sudo@ '

    runHook postFixup
  '';

  solutions.default = {
    scripts = [ "bin/dotfyls-install" ];
    interpreter = lib.getExe dash;
    inputs = [
      coreutils
      cryptsetup
      dosfstools
      gawk
      git
      gnugrep
      gptfdisk
      hostname
      jq
      ncurses
      nixos-enter
      nixos-generators
      nixos-install
      systemd
      util-linux
      which
      zfs
    ];
    fake.external = [
      "nix"
      "mount"
    ];
    keep."$nix" = true;
    execer = [
      "cannot:${lib.getExe git}"
      "cannot:${lib.getExe nixos-enter}"
      "cannot:${lib.getExe nixos-generators}"
      "cannot:${lib.getExe nixos-install}"
      "cannot:${lib.getExe' systemd "systemctl"}"
      "cannot:${lib.getExe' util-linux "swapon"}"
      "cannot:${lib.getExe zfs}"
      "cannot:${lib.getExe' zfs "zpool"}"
    ];
  };

  meta = {
    description = "Convenience installer for my personal dotfyls configuration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "dotfyls-install";
    platforms = lib.platforms.linux;
  };
}).overrideAttrs
  {
    postFixup = ''
      substituteInPlace $out/bin/dotfyls-install --replace-fail 'command --id=@command_present@ ' 'command_present '
      substituteInPlace $out/bin/dotfyls-install --replace-fail 'command --id=@run_sudo@ ' 'run_sudo '
      substituteInPlace $out/bin/dotfyls-install --replace-fail 'command --id=@run@ ' 'run '
      substituteInPlace $out/bin/dotfyls-install --replace-fail 'command --id=@sudo@ ' 'sudo '
    '';
  }

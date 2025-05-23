{ lib, rustPlatform }:

let
  manifest = (lib.importTOML ../Cargo.toml).package;
in
rustPlatform.buildRustPackage {
  pname = manifest.name;
  inherit (manifest) version;

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../Cargo.lock
      ../Cargo.toml
      (lib.fileset.fileFilter (file: lib.strings.hasSuffix ".rs" file.name) ../.)
    ];
  };
  cargoLock.lockFile = ../Cargo.lock;

  meta = {
    inherit (manifest) description;
    homepage = manifest.repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = manifest.name;
    platforms = lib.platforms.linux;
  };
}

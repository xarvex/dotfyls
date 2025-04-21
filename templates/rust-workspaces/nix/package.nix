{ lib, rustPlatform }:

let
  manifest = (lib.importTOML ../Cargo.toml).workspace.package;
in
rustPlatform.buildRustPackage {
  pname = "project-slug";
  inherit (manifest) version;

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../Cargo.lock
      (lib.fileset.fileFilter (
        file: file.name == "Cargo.toml" || lib.strings.hasSuffix ".rs" file.name
      ) ../.)
    ];
  };
  cargoLock.lockFile = ../Cargo.lock;

  meta = {
    inherit (manifest) description;
    homepage = manifest.repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = "project-slug";
    platforms = lib.platforms.linux;
  };
}

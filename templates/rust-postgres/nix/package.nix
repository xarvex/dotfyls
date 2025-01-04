{ lib, rustPlatform }:

let
  manifest = (lib.importTOML ../Cargo.toml).package;
in
rustPlatform.buildRustPackage rec {
  pname = manifest.name;
  inherit (manifest) version;

  src = ../.;
  cargoLock.lockFile = ../Cargo.lock;

  meta = {
    inherit (manifest) description;
    homepage = manifest.repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = pname;
    platforms = lib.platforms.linux;
  };
}

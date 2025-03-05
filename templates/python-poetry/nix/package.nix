{
  lib,

  poetry2nix,
}:

let
  pyproject = (lib.importTOML ./pyproject.toml).tool.poetry;
in
poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  meta = {
    inherit (pyproject) description;
    homepage = pyproject.repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = pyproject.name;
    platforms = lib.platforms.linux;
  };
}

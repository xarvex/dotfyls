{
  buildPythonPackage,
  hatchling,
  lib,
}:

let
  pyproject = (lib.importTOML ../../pyproject.toml).project;
in
buildPythonPackage {
  pname = pyproject.name;
  inherit (pyproject) version;

  src = ../.;

  pythonImportsCheck = [ pyproject.name ];

  build-system = [ hatchling ];

  meta = {
    inherit (pyproject) description;
    homepage = pyproject.urls.Repository;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xarvex ];
    mainProgram = pyproject.name;
    platforms = lib.platforms.linux;
  };
}

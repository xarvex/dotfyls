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

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../pyproject.toml
      (lib.fileset.fileFilter (file: lib.strings.hasSuffix ".py" file.name) ../.)
    ];
  };

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

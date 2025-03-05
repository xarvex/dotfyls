{
  callPackages,
  lib,

  pyproject-nix,
  pythonSet,
  uv-workspace,
}:

(callPackages pyproject-nix.build.util { }).mkApplication {
  venv = pythonSet.mkVirtualEnv "project-slug-virtualenv" uv-workspace.deps.default;
  package = pythonSet.project-slug.overrideAttrs (o: {
    meta = (o.meta or { }) // {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ xarvex ];
      platforms = lib.platforms.linux;
    };
  });
}

{
  lib,
  pkgs,
  pythonSet,
  self,
  uv-workspace,
  ...
}:

let
  inherit (self.checks.${pkgs.system}) pre-commit;

  editablePythonSet = pythonSet.overrideScope (
    lib.composeManyExtensions [
      (uv-workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; })
      (final: prev: {
        project-slug = prev.project-slug.overrideAttrs (o: {
          src = lib.fileset.toSource {
            root = o.src;
            fileset = lib.fileset.unions [
              (o.src + "/src/project_slug/__main__.py")
              (o.src + "/README.md")
              (o.src + "/pyproject.toml")
            ];
          };

          nativeBuildInputs = o.nativeBuildInputs ++ final.resolveBuildSystem { editables = [ ]; };
        });
      })
    ]
  );
  virtualenv = editablePythonSet.mkVirtualEnv "project-slug-virtualenv" uv-workspace.deps.all;
in
pkgs.mkShellNoCC {
  nativeBuildInputs = pre-commit.enabledPackages ++ [ virtualenv ] ++ (with pkgs; [ uv ]);

  env = {
    UV_NO_SYNC = "1";
    UV_PYTHON = lib.getExe' virtualenv "python";
    UV_PYTHON_DOWNLOADS = "never";
  };

  shellHook = pre-commit.shellHook + ''
    unset PYTHONPATH
    REPO_ROOT=$(git rev-parse --show-toplevel)
    export REPO_ROOT
  '';
}

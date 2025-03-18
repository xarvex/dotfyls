{
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (self.checks.${pkgs.system}) pre-commit;

  python = pkgs.python312;
in
pkgs.mkShellNoCC {
  nativeBuildInputs = pre-commit.enabledPackages ++ (with pkgs; [ uv ]);
  buildInputs = [ python ];

  env = {
    UV_NO_SYNC = "1";
    UV_PYTHON_DOWNLOADS = "never";
  };

  shellHook =
    pre-commit.shellHook
    # bash
    + ''
      venv="''${UV_PROJECT_ENVIRONMENT:-.venv}"

      if [ ! -f "''${venv}"/bin/activate ] || [ "$(readlink -f "''${venv}"/bin/python)" != "$(readlink -f ${lib.getExe python})" ]; then
          printf '%s\n' 'Regenerating virtual environment, Python interpreter changed...' >&2
          rm -rf "''${venv}"
          uv venv --python ${lib.getExe python} "''${venv}"
      fi

      source "''${venv}"/bin/activate

      if [ ! -f "''${venv}"/pyproject.toml ] || ! diff --brief pyproject.toml "''${venv}"/pyproject.toml >/dev/null; then
          printf '%s\n' 'Installing dependencies, pyproject.toml changed...' >&2
          uv pip install --quiet --editable '.[mkdocs,mypy,pre-commit,pytest]'
          cp pyproject.toml "''${venv}"/pyproject.toml
      fi
    '';
}

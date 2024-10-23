rec {
  c = {
    path = ./c;
    description = "C development environment.";
  };

  golang = go;
  go = {
    path = ./go;
    description = "Go development environment.";
  };

  js = javascript;
  javascript = {
    path = ./javascript;
    description = "JavaScript/TypeScript development environment.";
  };

  lua = {
    path = ./lua;
    description = "Lua(JIT) development environment.";
  };

  py = python;
  python = python-poetry;

  py-poetry = python-poetry;
  python-poetry = {
    path = ./python-poetry;
    description = "Python development environment with Poetry.";
  };

  py-uv = python-uv;
  python-uv = {
    path = ./python-uv;
    description = "Python development environment with uv.";
  };

  py-venv = python-venv;
  python-venv = {
    path = ./python-venv;
    description = "Python development environment with venv.";
  };

  rs = rust;
  rust = {
    path = ./rust;
    description = "Rust development environment.";
  };

  rs-pg = rust-postgres;
  rs-postgres = rust-postgres;
  rust-pg = rust-postgres;
  rust-postgres = {
    path = ./rust-postgres;
    description = "Rust development environment with Postgres database.";
  };

  rs-work = rust-workspaces;
  rs-workspace = rust-workspaces;
  rs-workspaces = rust-workspaces;
  rust-work = rust-workspaces;
  rust-workspace = rust-workspaces;
  rust-workspaces = {
    path = ./rust-workspaces;
    description = "Rust development environment with Cargo workspaces.";
  };

  ts = typescript;
  typescript = javascript;
}

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
  python = {
    path = ./python;
    description = "Python development environment.";
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

  ts = typescript;
  typescript = javascript;
}

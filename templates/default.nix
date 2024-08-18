rec {
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
}

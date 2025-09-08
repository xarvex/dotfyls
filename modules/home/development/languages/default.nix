# Motivation for including all these tools in my home is that they can still
# be overridden via PATH per-project. I have these tools to accelerate and
# give ease towards working on something quickly.
# Also, quite simply, not all of these need to be per-project.

{ lib, ... }:

{
  imports = [
    ./go
    ./javascript

    ./blueprint.nix
    ./c.nix
    ./css.nix
    ./html.nix
    ./java.nix
    ./json.nix
    ./kotlin.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./shellscript.nix
    ./slint.nix
    ./sql.nix
    ./toml.nix
    ./typescript.nix
    ./typst.nix
    ./vala.nix
    ./yaml.nix
    ./zig.nix
  ];

  options.dotfyls.development.languages.defaultEnable =
    lib.mkEnableOption "all languages by default"
    // {
      default = true;
    };
}

{ lib }:

{
  moduleNameOf = path: lib.removeSuffix ".nix" (builtins.baseNameOf path);
}

{ lib, self }:

{
  configuration = import ./configuration.nix { inherit self; };
  modules = import ./modules.nix { inherit lib; };
}

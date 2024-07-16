{ lib, ... }:

{
  # generator = workspace: key: ()
  genList = generator: builtins.genList
    (n:
      let workspace = n + 1; in
      generator workspace (toString (lib.mod workspace 10))) 10;
}

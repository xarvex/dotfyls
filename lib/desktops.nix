{ lib }:

{
  # generator = workspace: key: ()
  genWorkspaceList = generator: builtins.genList
    (n:
      let workspace = n + 1; in
      generator workspace (toString (lib.mod workspace 10))) 10;
}

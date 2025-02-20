{ lib }:

rec {
  # generator = display: workspace: key: ()
  genWorkspaceList' =
    generator: displays:
    builtins.concatMap (
      display:
      map (workspace: generator display workspace (toString (lib.mod workspace 10))) display.workspaces
    ) displays;

  # generator = workspace: key: ()
  genWorkspaceList =
    generator:
    genWorkspaceList' (_: generator) [
      { workspaces = builtins.genList (workspace: workspace + 1) 10; }
    ];
}

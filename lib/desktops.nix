{ lib }:

rec {
  # generator = display: workspace: key: ()
  genWorkspaceList' =
    generator: displays:
    builtins.concatMap (
      display:
      let
        workspaces = 10 / (builtins.length displays);
      in
      builtins.genList (
        n:
        let
          workspace = (n + 1) + (workspaces * display.index);
        in
        generator display.value workspace (toString (lib.mod workspace 10))
      ) workspaces
    ) (lib.imap0 (index: value: { inherit index value; }) displays);

  # generator = workspace: key: ()
  genWorkspaceList = generator: genWorkspaceList' (_: generator) [ null ];
}

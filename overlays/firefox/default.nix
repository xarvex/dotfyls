_: prev:

let
  containerSort = prev.writeShellApplication {
    name = "firefox-container-sort";

    runtimeInputs = with prev; [
      jq
      moreutils
    ];

    text = builtins.readFile ./container-sort.sh;
  };
in
prev.firefox.overrideAttrs (o: {
  buildCommand =
    let
      find = "makeWrapper \"$oldExe\" \\\n  \"\${executablePath}\" \\\n";
    in
    builtins.replaceStrings [ find ] [
      (find + "    --run \"${prev.lib.getExe containerSort}\" \\\n")
    ] o.buildCommand;
})

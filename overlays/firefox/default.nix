final: prev:

let
  containerSort = final.writeShellApplication {
    name = "firefox-container-sort";

    runtimeInputs = with final; [
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
      (find + "    --run \"${final.lib.getExe containerSort}\" \\\n")
    ] o.buildCommand;
})

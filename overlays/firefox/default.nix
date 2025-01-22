final: prev:

let
  containerSort = final.writeShellApplication {
    name = "dotfyls-firefox-container-sort";

    runtimeInputs = with final; [
      jq
      moreutils
    ];

    text = builtins.readFile ./container-sort.sh;
  };
in
prev.firefox.overrideAttrs (o: {
  makeWrapperArgs = o.makeWrapperArgs ++ [
    "--run"
    (final.lib.getExe containerSort)
  ];
})

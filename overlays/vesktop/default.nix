final: prev:

prev.vesktop.overrideAttrs (
  o:
  let
    disableFirstLaunch = final.writeShellApplication {
      name = "vesktop-disable-first-launch";

      runtimeInputs = with final; [ coreutils ];

      text = builtins.readFile ./disable-first-launch.sh;
    };
  in
  {
    nativeBuildInputs = o.nativeBuildInputs ++ [ final.makeWrapper ];

    postFixup =
      (o.postFixup or "")
      + ''
        wrapProgram $out/bin/vesktop --run "${final.lib.getExe disableFirstLaunch}"
      '';
  }
)

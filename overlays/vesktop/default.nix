_: final: prev:

(prev.vesktop.overrideAttrs (
  o:
  let
    disableFirstLaunch = final.writeShellApplication {
      name = "dotfyls-vesktop-disable-first-launch";

      runtimeInputs = with final; [ coreutils ];

      text = builtins.readFile ./disable-first-launch.sh;
    };
  in
  {
    nativeBuildInputs = o.nativeBuildInputs ++ [ final.makeWrapper ];

    patches = (o.patches or [ ]) ++ [ ./remove-splash-image.patch ];

    postFixup =
      (o.postFixup or "")
      + ''
        wrapProgram $out/bin/vesktop --run "${final.lib.getExe disableFirstLaunch}"
      '';
  }
)).override
  {
    vencord = prev.vencord.overrideAttrs (o: {
      postInstall =
        (o.postInstall or "")
        # bash
        + ''
          cp package.json $out
        '';
    });
  }

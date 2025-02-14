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
    # INFO: Electron 34 breaks notifications and screensharing.
    electron =
      assert (
        final.lib.assertMsg (final.lib.versionAtLeast "34.1.1" final.electron.version) "Electron updated, check if override on Vesktop is still needed"
      );
      final.electron_33;
  }

{ dotfyls, pkgs }:

dotfyls.overrideAttrs (o: {
  nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ (with pkgs; [ luajit ]);
})

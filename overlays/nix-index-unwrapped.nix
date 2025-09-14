_: final: prev:

# https://github.com/nix-community/nix-index/issues/210
final.symlinkJoin {
  inherit (prev.nix-index-unwrapped)
    pname
    name
    version
    meta
    ;

  paths = [ prev.nix-index-unwrapped ];

  nativeBuildInputs = with final; [ coreutils ];

  postBuild = ''
    mv $out/etc/profile.d/command-not-found.sh{,.orig}
    substitute $out/etc/profile.d/command-not-found.sh{.orig,} \
        --replace-fail ${prev.nix-index-unwrapped} $out \
        --replace-fail '[ -e "$HOME/.nix-profile/manifest.json" ]' true
    rm $out/etc/profile.d/command-not-found.sh.orig
  '';
}

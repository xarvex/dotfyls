_: _: prev:

# https://github.com/nix-community/nix-index/issues/210
prev.nix-index-unwrapped.overrideAttrs (o: {
  postInstall = ''
    substituteInPlace command-not-found.sh \
        --replace-fail '[ -e "$HOME/.nix-profile/manifest.json" ]' true
  ''
  + (o.postInstall or "");
})

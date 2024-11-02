_: prev:

# Requires legacy OpenSSL compatibility, limit to just this package.
# WARNING: untested
prev.evil-winrm.overrideAttrs (o: {
  nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];

  postFixup =
    (o.postFixup or "")
    + ''
      wrapProgram $out/bin/evil-winrm --prefix OPENSSL_CONF : ${./openssl.conf}
    '';
})

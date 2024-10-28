final: prev:

assert final.lib.assertMsg (final.lib.versionOlder prev.starship.version "1.21")
  "Starship 1.21 has been released";
prev.starship.overrideAttrs (o: rec {
  version = "1.21.1";

  src = final.fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-Xn9qV26/ST+3VtVq6OJP823lIVIo0zEdno+nIUv8B9c=";
  };

  cargoDeps = o.cargoDeps.overrideAttrs (_: {
    inherit src;

    name = "starship-${version}-vendor.tar.gz";
    outputHash = "sha256-YbZCe2OcX/wq0OWvWK61nWvRT0O+CyW0QY0J7vv6QaM=";
  });
})

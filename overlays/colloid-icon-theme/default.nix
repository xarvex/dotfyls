_: final: prev:

assert (
  final.lib.assertMsg (final.lib.versionAtLeast "2025-02-09" prev.colloid-icon-theme.version) "colloid-icon-theme updated, check if overlay still needed"
);
prev.colloid-icon-theme.overrideAttrs {
  dontCheckForBrokenSymlinks = true;
}

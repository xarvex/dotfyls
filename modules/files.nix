filesystem:
{ lib, ... }:

{
  options.dotfyls.files = {
    persistFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in ${filesystem} filesystem.";
    };
    persistDirectories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in ${filesystem} filesystem.";
    };

    cacheFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in ${filesystem} filesystem, but not to snapshot.";
    };
    cacheDirectories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in ${filesystem} filesystem, but not to snapshot.";
    };
  };
}

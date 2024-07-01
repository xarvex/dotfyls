{ lib, ... }:

{
  options.dotfyls.persist = {
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in root filesystem.";
    };

    directories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in root filesystem.";
    };

    cache = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in root filesystem, but not to snapshot.";
    };
  };

  config.dotfyls.persist = {
    files = [ "/etc/machine-id" ];
    directories = [ "/var/log" ];
  };
}

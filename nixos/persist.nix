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

    cacheFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in root filesystem, but not to snapshot.";
    };
    cacheDirectories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in root filesystem, but not to snapshot.";
    };
  };

  config.dotfyls.persist = {
    files = [
      # Licensed software such as Spotify may check the value.
      "/etc/machine-id"
    ];
    directories = [
      "/var/lib/nixos"
      "/var/log"
    ];
    cacheDirectories = [
      "/var/lib/systemd/coredump"
      "/root/.cache/nix"
    ];
  };
}

{ lib, ... }:

{
  options.dotfyls.persist = {
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in home filesystem.";
    };

    directories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in home filesystem.";
    };

    cacheFiles = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Files to persist in home filesystem, but not to snapshot.";
    };
    cacheDirectories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in home filesystem, but not to snapshot.";
    };
  };

  config.dotfyls.persist = {
    directories = [
      "Desktop"
      "Documents"
      "Pictures"
      "Videos"
      ".ssh"
    ];
    cacheDirectories = [
      ".cache/nix"
      ".cache/nixpkgs-review"
    ];
  };
}

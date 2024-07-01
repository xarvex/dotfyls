{ lib, ... }:

{
  options.custom.persist = {
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

    cache = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Directories to persist in home filesystem, but not to snapshot.";
    };
  };

  config.custom.persist = {
    directories = [ "Desktop" "Documents" "Pictures" ];
    cache = [ ".cache/nix" ".cache/nixpkgs-review" ];
  };
}

{ self, ... }:

{
  imports = [ self.homeManagerModules.files ];

  config.dotfyls.files = {
    persistDirectories = [
      "Desktop"
      "Documents"
      "Pictures"
      "Videos"
    ];
    cacheDirectories = [
      ".cache/nix"
      ".cache/nixpkgs-review"
    ];
  };
}

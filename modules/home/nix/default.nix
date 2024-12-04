{ self, ... }:

{
  imports = [
    self.homeManagerModules.nix

    ./helper.nix
    ./index.nix
  ];

  dotfyls.file.".cache/nix".cache = true;
}

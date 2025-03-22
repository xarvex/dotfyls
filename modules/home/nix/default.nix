{ self, ... }:

{
  imports = [
    self.homeModules.nix

    ./helper.nix
    ./index.nix
  ];

  dotfyls.file.".cache/nix".cache = true;
}

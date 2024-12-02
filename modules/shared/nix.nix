system:
{
  lib,
  pkgs,
  self,
  ...
}:

{
  nix = rec {
    package = if system then pkgs.nixVersions.latest else lib.mkDefault pkgs.nixVersions.latest;
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    gc = {
      automatic = true;

      options = "--delete-older-than 14d";
    } // (lib.setAttrByPath [ (if system then "dates" else "frequency") ] "daily");

    settings = {
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix-path = nixPath;

      substituters = [
        "https://devenv.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs.overlays = [ self.overlays.default ];
}

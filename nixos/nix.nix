{ pkgs, ... }:

{
  nix = rec {
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    channel.enable = false;

    package = pkgs.nixVersions.latest;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };

    settings = {
      nix-path = nixPath;

      auto-optimise-store = true;
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

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

  systemd.tmpfiles.rules = [ "R /nix/var/nix/profiles/per-user - - - 0" ];
}

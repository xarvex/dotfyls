{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.nix;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "nix"
        "helper"
      ]
      [
        "programs"
        "nh"
      ]
    )
  ];

  options.dotfyls.nix.helper.enable = lib.mkEnableOption "nh" // {
    default = true;
  };

  config = {
    dotfyls.files = {
      # TODO: Confirm permissions.
      "/var/lib/nixos".persist = true;

      "/root/.cache/nix".cache = true;
    };

    nix = rec {
      channel.enable = false;
      package = pkgs.nixVersions.latest;
      nixPath = [ "nixpkgs=flake:nixpkgs" ];

      gc = {
        automatic = true;

        dates = "daily";
        options = "--delete-older-than 14d";
      };

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

    programs.nh.enable = lib.mkIf cfg.helper.enable true;

    systemd.tmpfiles.rules = [ "R /nix/var/nix/profiles/per-user - - - 0" ];
  };
}

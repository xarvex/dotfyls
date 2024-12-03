{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.nix;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
    self.nixosModules.nix

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
    dotfyls.file = {
      # TODO: Confirm permissions.
      "/var/lib/nixos".persist = true;

      "/root/.cache/nix".cache = true;
    };

    nix.channel.enable = false;

    programs.nh.enable = lib.mkIf cfg.helper.enable true;

    systemd.tmpfiles.rules = [ "R /nix/var/nix/profiles/per-user - - - 0" ];
  };
}

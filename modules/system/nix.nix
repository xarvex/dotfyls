{ inputs, self, ... }:

{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
    self.nixosModules.nix
  ];

  dotfyls.file = {
    # TODO: Confirm permissions.
    "/var/lib/nixos".persist = true;

    "/root/.cache/nix".cache = true;
  };

  nix.channel.enable = false;

  systemd.tmpfiles.rules = [ "R /nix/var/nix/profiles/per-user - - - 0" ];
}

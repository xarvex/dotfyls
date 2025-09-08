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

  nix = {
    channel.enable = false;
    optimise = {
      automatic = true;

      dates = [ "*-*-* 06:00:00" ];
    };
  };

  systemd.tmpfiles.settings.dotfyls-nix."/nix/var/nix/profiles/per-user".R.age = "0";
}

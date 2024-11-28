{ self, ... }:

{
  imports = [ self.homeManagerModules.files ];

  config.dotfyls.files = {
    persistFiles = [
      # Licensed software such as Spotify may check the value.
      "/etc/machine-id"
    ];
    persistDirectories = [
      "/var/lib/nixos"
      "/var/log"
    ];
    cacheDirectories = [
      "/var/lib/systemd/coredump"
      "/root/.cache/nix"
    ];
  };
}

{ self, ... }:

{
  imports = [
    ./appearance
    ./boot
    ./desktops
    ./display-manager
    ./filesystems
    ./graphics
    ./kernels.nix
    ./localization.nix
    ./media
    ./networking.nix
    ./nix.nix
    ./power.nix
    ./programs
    ./security
    ./shells.nix
    ./users.nix

    self.nixosModules.files
  ];

  dotfyls.files = {
    # Licensed software such as Spotify may check the value.
    "/etc/machine-id" = {
      dir = false;
      mode = "0444";
      persist = true;
    };

    "/var/lib/systemd/coredump".cache = true;
    "/var/log".persist = true;

    "/root/.cache".mode = "0700";
  };

  services.dbus.implementation = "broker";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

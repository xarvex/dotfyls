_:

{
  imports = [
    ./appearance
    ./boot
    ./desktops
    ./display-manager
    ./files
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
    ./state.nix
    ./users.nix
  ];

  dotfyls.file = {
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
}

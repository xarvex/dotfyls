{ self, ... }:

{
  imports = [
    self.nixosModules.meta

    ./appearance
    ./boot
    ./containers
    ./desktops
    ./display-managers
    ./files
    ./filesystems
    ./games
    ./graphics
    ./management
    ./media
    ./networking
    ./security

    ./home-manager.nix
    ./nix.nix
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

    "/var/lib/systemd/catalog".cache = true;
    "/var/lib/systemd/coredump".cache = true;
    "/var/lib/systemd/timers".cache = true;
    "/var/lib/systemd/timesync".cache = true;

    "/var/log".persist = true;

    "/var/lib/private".mode = "0700";
    "/var/cache/private".mode = "0700";

    "/root/.cache".mode = "0700";
  };

  environment.etc.issue.text = ''
    Welcome to \e{cyan}\S\e{reset} on \e{magenta}\n\e{reset} (\e{yellow}\l\e{reset})

  '';

  services.dbus.implementation = "broker";

  systemd.enableStrictShellChecks = true;
}

_:

{
  imports = [
    ./appearance
    ./boot
    ./desktops
    ./display-managers
    ./files
    ./games
    ./graphics
    ./input
    ./management
    ./media
    ./networking
    ./programs
    ./security

    ./home-manager.nix
    ./nix.nix
    ./shells.nix
    ./state.nix
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

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
    \e]P026233A\e]P1EB6F92\e]P231748F\e]P3F6C177\e]P49CCFD8\e]P5C4A7E7\e]P6EBBCBA\e]P7E0DEF4\e]P86E6A86\e]P9EB6F92\e]PA31748F\e]PBF6C177\e]PC9CCFD8\e]PDC4A7E7\e]PEEBBCBA\e]PFE0DEF4[H[2J
    Welcome to \e{cyan}\S\e{reset} on \e{magenta}\n\e{reset} (\e{yellow}\l\e{reset})

  '';

  services.dbus.implementation = "broker";
}

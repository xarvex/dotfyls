{ user, ... }:

{
  imports = [
    ./appearance
    ./browsers
    ./desktops
    ./development
    ./files
    ./games
    ./graphics
    ./management
    ./media
    ./networking
    ./nix
    ./programs
    ./security
    ./shells
    ./terminals

    ./icon.nix
    ./mime-apps.nix
    ./state.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs.home-manager.enable = true;
}

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
    ./media
    ./nix
    ./programs
    ./security
    ./shells
    ./terminals

    ./icon.nix
    ./state.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs.home-manager.enable = true;
}

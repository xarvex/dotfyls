{ user, ... }:

{
  imports = [
    ./appearance
    ./browsers
    ./desktops
    ./development
    ./files
    ./games
    ./media
    ./nix
    ./programs
    ./security
    ./shells
    ./terminals

    ./graphics.nix
    ./state.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs.home-manager.enable = true;
}

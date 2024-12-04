_:

{
  imports = [
    ./appearance
    ./desktops
    ./development
    ./files
    ./media
    ./nix
    ./programs
    ./security
    ./shells
    ./terminals

    ./graphics.nix
    ./state.nix
  ];

  programs.home-manager.enable = true;
}

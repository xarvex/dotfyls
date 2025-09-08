{ config, self, ... }:

{
  imports = [
    self.homeModules.meta

    ./appearance
    ./browsers
    ./containers
    ./desktops
    ./development
    ./editors
    ./files
    ./filesystems
    ./games
    ./graphics
    ./management
    ./media
    ./networking
    ./security
    ./shells
    ./social
    ./terminals

    ./icon.nix
    ./nix.nix
    ./state.nix
  ];

  dotfyls.file.".local/share/systemd/timers".cache = true;

  home = {
    username = config.dotfyls.meta.user;
    homeDirectory = config.dotfyls.meta.home;
  };

  programs.home-manager.enable = true;
}

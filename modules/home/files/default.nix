{ config, self, ... }:

{
  imports = [
    self.homeManagerModules.file

    ./nemo
    ./neovim
    ./obsidian

    ./gvfs.nix
    ./sync.nix
  ];

  dotfyls.file = {
    "Documents" = {
      mode = "0700";
      persist = true;
      sync = {
        enable = true;
        rescan = 0;
        watch.delay = 60;
        order = "newestFirst";
      };
    };
    "Downloads" = {
      mode = "0700";
      cache = true;
      sync = {
        enable = true;
        watch.enable = false;
        order = "smallestFirst";
      };
    };
    "Music" = {
      mode = "0700";
      persist = true;
      sync.enable = true;
    };
    "Pictures" = {
      mode = "0700";
      persist = true;
      sync.enable = true;
    };
    "Videos" = {
      mode = "0700";
      persist = true;
      sync.enable = true;
    };

    ".config".mode = "0700";
    ".local".mode = "0700";
    ".local/share".mode = "0700";
    ".local/state".mode = "0700";
    ".cache".mode = "0700";

    ".local/share/Trash" = {
      mode = "0700";
      cache = true;
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  gtk.gtk3.bookmarks = with config.xdg.userDirs; [
    "file://${documents}"
    "file://${download}"
    "file://${music}"
    "file://${pictures}"
    "file://${videos}"
  ];
}

{ config, self, ... }:

{
  imports = [
    self.homeManagerModules.file

    ./nemo

    ./gvfs.nix
  ];

  dotfyls.file = {
    "Documents" = {
      mode = "0700";
      persist = true;
    };
    "Downloads" = {
      mode = "0700";
      cache = true;
    };
    "Music" = {
      mode = "0700";
      persist = true;
    };
    "Pictures" = {
      mode = "0700";
      persist = true;
    };
    "Videos" = {
      mode = "0700";
      persist = true;
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

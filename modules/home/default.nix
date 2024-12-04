{ self, ... }:

{
  imports = [
    ./appearance
    ./desktops
    ./development
    ./files
    ./media
    ./programs
    ./security
    ./shells
    ./terminals

    ./graphics.nix
    ./state.nix

    self.homeManagerModules.nix
  ];

  dotfyls.file = {
    "Documents".persist = true;
    "Pictures".persist = true;
    "Videos".persist = true;

    ".config".mode = "0700";

    ".local".mode = "0700";

    ".local/share".mode = "0700";
    ".local/state".mode = "0700";

    ".cache".mode = "0700";

    ".cache/nix".cache = true;
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
  };
}

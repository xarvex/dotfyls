{ self, ... }:

{
  imports = [
    ./appearance
    ./desktops
    ./development
    ./media
    ./programs
    ./security
    ./shells
    ./terminals

    ./graphics.nix

    self.homeManagerModules.files
  ];

  dotfyls.files = {
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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
  };
}

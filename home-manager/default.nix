{ pkgs, user, ... }:

{
  imports = [
    ./desktop
    ./persist.nix
    ./programs
    ./terminals
    ./shells
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      nil
      nixpkgs-fmt
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;
  };
}

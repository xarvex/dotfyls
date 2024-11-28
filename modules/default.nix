{
  nixosModules.files = import ./files.nix "root";

  homeManagerModules.files = import ./files.nix "home";
}

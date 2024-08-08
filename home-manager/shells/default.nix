{ self, ... }:

{
  imports = [
    ./zsh.nix

    (self.lib.mkSelectorModule [ "dotfyls" "shells" ]
      {
        name = "default";
        default = "zsh";
        description = "Default shell to use.";
      }
      {
        zsh = "Zsh";
      })
  ];
}

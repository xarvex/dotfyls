{
  config,
  lib,
  self,
  ...
}:

{
  imports = [
    ./cage.nix
    ./greetd.nix
    ./sddm.nix

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "displayManager"
      ]
      {
        name = "provider";
        default = "greetd";
        description = "Display manager to use.";
      }
      [
        "cage"
        "greetd"
        "sddm"
      ]
    )
  ];

  options.dotfyls.displayManager.enable = lib.mkEnableOption "display manager" // {
    default = config.dotfyls.desktops.enable;
  };
}

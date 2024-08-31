{
  config,
  lib,
  self,
  ...
}:

{
  imports = [
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
        "greetd"
        "sddm"
      ]
    )
  ];

  options.dotfyls.displayManager.enable = lib.mkEnableOption "display manager" // {
    default = config.dotfyls.desktops.enable;
  };
}

{
  config,
  lib,
  self,
  ...
}:

{
  imports = [
    ./cage
    ./greetd
    ./sddm

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "displayManager"
      ]
      {
        name = "provider";
        default = "greetd";
        example = "sddm";
        description = "Display manager to use.";
      }
    )
  ];

  options.dotfyls.displayManager.enable = lib.mkEnableOption "display manager" // {
    default = config.dotfyls.desktops.enable;
  };
}

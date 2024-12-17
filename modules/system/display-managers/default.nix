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

    (self.lib.mkSelectorModule [ "dotfyls" "display-managers" ] {
      name = "provider";
      default = "greetd";
      example = "sddm";
      description = "Display manager to use.";
    })
  ];

  options.dotfyls.display-managers.enable = lib.mkEnableOption "display managers" // {
    default = config.dotfyls.desktops.enable;
  };
}

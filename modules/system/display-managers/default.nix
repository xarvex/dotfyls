{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.display-managers;
in
{
  imports = [
    ./greetd

    ./sddm.nix
  ];

  options.dotfyls.display-managers = {
    enable = lib.mkEnableOption "display managers" // {
      default = config.dotfyls.desktops.enable;
    };
    provider = lib.mkOption {
      type = lib.types.enum [
        "greetd"
        "sddm"
      ];
      default = "greetd";
      example = "sddm";
      description = "Display manager to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.display-managers = self.lib.enableSelected cfg.provider [
      "greetd"
      "sddm"
    ];
  };
}

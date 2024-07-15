{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.nemo.enable = lib.mkEnableOption "Nemo" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.nemo.enable {
    home.packages = with pkgs; [
      cinnamon.nemo-with-extensions
      webp-pixbuf-loader
    ];
  };
}

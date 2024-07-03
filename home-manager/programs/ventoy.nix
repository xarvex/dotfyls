{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.ventoy.enable = lib.mkEnableOption "Ventoy" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.ventoy.enable {
    home.packages = with pkgs; [ ventoy-full ];
  };
}

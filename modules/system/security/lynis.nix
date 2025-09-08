{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.security.lynis;
in
{
  options.dotfyls.security.lynis.enable = lib.mkEnableOption "Lynis" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ lynis ]; };
}
